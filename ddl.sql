CREATE TABLE traffic (
       sensor_id   INTEGER   NOT NULL,
       record_date TIMESTAMP NOT NULL,
       record_time TIMESTAMP NOT NULL,
       direction   TINYINT   NOT NULL,
       lane        TINYINT   NOT NULL,
       cnt         INTEGER   NOT NULL,
);
PARTITION TABLE traffic on COLUMN sensor_id;

CREATE INDEX idx_traffic ON traffic (
       sensor_id, record_date
);

CREATE VIEW v_traffic_by_sensor_date (
       sensor_id,
       date,
       total,
       cnt
) AS
  SELECT sensor_id,
         record_date,
         COUNT(*),
         SUM(cnt)
  FROM traffic
  GROUP BY sensor_id, record_date;


-- Alerts table and an evolved Insert procedure
-- CREATE TABLE alerts (
--        sensor_id   INTEGER NOT NULL,
--        record_time TIMESTAMP NOT NULL,
--        PRIMARY KEY (
--                sensor_id, record_time
--        )
-- );
-- PARTITION TABLE alerts on COLUMN sensor_id;
-- CREATE PROCEDURE FROM CLASS procedures.InsertAlert;


-- Export table and further evolved Insert procedure
-- CREATE TABLE alerts_export (
--        sensor_id   INTEGER NOT NULL,
--        record_time TIMESTAMP NOT NULL,
-- );
-- EXPORT TABLE alerts_export;
-- CREATE PROCEDURE FROM CLASS procedures.InsertAlertExport;

