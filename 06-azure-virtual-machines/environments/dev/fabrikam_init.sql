CREATE TABLE IF NOT EXISTS public.fabrikam
(
    id integer NOT NULL,
    name character varying(50) COLLATE pg_catalog."default",
    location character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT fabrikam_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.fabrikam
    OWNER to tfmulticlouddevadmin;

INSERT INTO public.fabrikam (id, name, location) VALUES (1, 'Fabrikam', 'Redmond');