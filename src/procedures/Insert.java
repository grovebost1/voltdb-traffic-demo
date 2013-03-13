package procedures;

import java.util.*;
import org.voltdb.*;
import org.voltdb.types.TimestampType;

@ProcInfo (
    partitionInfo = "traffic.sensor_id:0",
    singlePartition = true
    )
public class Insert extends VoltProcedure {
    public final SQLStmt insertTraffic =
        new SQLStmt("INSERT INTO traffic VALUES (?, ?, ?, ?, ?, ?);");
    public final SQLStmt getTotalForDay =
        new SQLStmt("SELECT cnt FROM v_traffic_by_sensor_date WHERE sensor_id = ? AND date = ?;");
    public final SQLStmt checkAlert =
        new SQLStmt("SELECT * FROM alerts WHERE sensor_id = ? AND record_time = ?;");
    public final SQLStmt insertAlert =
        new SQLStmt("INSERT INTO alerts VALUES (?, ?);");

    public long run(int sensor_id, TimestampType record_date, TimestampType record_time,
                    byte direction, byte lane, int cnt) {
        voltQueueSQL(insertTraffic, sensor_id, record_date, record_time,
                     direction, lane, cnt);
        voltQueueSQL(getTotalForDay, sensor_id, record_date);
        voltQueueSQL(checkAlert, sensor_id, record_date);
        VoltTable[] results = voltExecuteSQL();

        if (results[1].asScalarLong() >= 200000 && results[2].getRowCount() == 0) {
            voltQueueSQL(insertAlert, sensor_id, record_date);
            voltExecuteSQL(true);
            return 1;
        }

        return 0;
    }
}