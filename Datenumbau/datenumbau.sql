--java -jar /home/stefan/Apps/ili2pg-3.0.3/ili2pg.jar --dbhost localhost --dbport 5432 --dbdatabase xanadu2 --dbusr stefan --dbpwd ziegler12 --defaultSrsAuth EPSG --defaultSrsCode 21781 --createGeomIdx --strokeArcs --createUnique --nameByTopic --dbschema av_chenyx06_test5 --modeldir "http://models.geo.admin.ch;." --models SO_CHENyx06_20160701 --schemaimport

ALTER TABLE av_chenyx06_test5.chenyx06_tsp_geometry_lv95
 ALTER COLUMN geometry TYPE geometry(Point, 2056)
  USING ST_SetSRID(geometry, 2056);

WITH tsp AS
(
 SELECT lv03.anumber, lv03.state_of, 
        ST_PointFromText('POINT('|| lv03.ost ||' '|| lv03.nord ||')', 21781) as the_geom_lv03, 
        ST_PointFromText('POINT('|| lv95.ost ||' '|| lv95.nord ||')', 2056) as the_geom_lv95
 FROM av_chenyx06_datenumbau.tsp_lv03 as lv03,
      av_chenyx06_datenumbau.tsp_lv95 as lv95
 WHERE lv03.anumber = lv95.anumber
),
lv03_inserted AS
(
 INSERT INTO av_chenyx06_test5.chenyx06_tsp_geometry_lv03 (state_of, geometry)
 SELECT state_of, the_geom_lv03
 FROM tsp
 RETURNING *
),
lv95_inserted AS
(
 INSERT INTO av_chenyx06_test5.chenyx06_tsp_geometry_lv95 (state_of, geometry)
 SELECT state_of, the_geom_lv95
 FROM tsp
 RETURNING * 
),
tsp_inserted AS
(
 SELECT anumber, the_geom_lv03, the_geom_lv95, 
        lv03_inserted.t_id as lv03_t_id, lv95_inserted.t_id as lv95_t_id
 FROM tsp, lv03_inserted, lv95_inserted
 WHERE ST_AsEWKB(tsp.the_geom_lv03)  = ST_AsEWKB(lv03_inserted.geometry)
 AND ST_AsEWKB(tsp.the_geom_lv95)  = ST_AsEWKB(lv95_inserted.geometry)
)
INSERT INTO av_chenyx06_test5.chenyx06_tsp (anumber, geom_lv03, geom_lv95)
SELECT anumber, lv03_t_id,lv95_t_id
FROM tsp_inserted;


-- Kontrolle
/*
SELECT ST_AsText(geometry), *
FROM av_chenyx06_test5.chenyx06_tsp as tsp, av_chenyx06_test5.chenyx06_tsp_geometry_lv03 as lv03
WHERE tsp.geom_lv03 = lv03.t_id
ORDER BY anumber
*/
