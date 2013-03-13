CREATE TABLE traffic (
       sensor_id   INTEGER   NOT NULL,
       record_date TIMESTAMP NOT NULL,
       record_time TIMESTAMP NOT NULL,
       direction   TINYINT   NOT NULL,
       lane        TINYINT   NOT NULL,
       cnt         INTEGER   NOT NULL,
);

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

CREATE TABLE alerts (
       sensor_id   INTEGER NOT NULL,
       record_time TIMESTAMP NOT NULL,
       PRIMARY KEY (
               sensor_id, record_time
       )
);