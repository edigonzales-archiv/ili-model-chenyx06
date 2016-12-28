CREATE SCHEMA av_chenyx06_datenumbau
  AUTHORIZATION stefan;


CREATE TABLE av_chenyx06_datenumbau.tsp_lv03
(
  ogc_fid serial NOT NULL,
  anumber character varying,
  ost numeric(10,3),
  nord numeric(10,3),
  state_of integer,
  CONSTRAINT tsp_lv03_pkey PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=FALSE
);


CREATE TABLE av_chenyx06_datenumbau.tsp_lv95
(
  ogc_fid serial NOT NULL,
  anumber character varying,
  ost numeric(10,3),
  nord numeric(10,3),
  state_of integer,
  CONSTRAINT tsp_lv95_pkey PRIMARY KEY (ogc_fid)
)
WITH (
  OIDS=FALSE
);
