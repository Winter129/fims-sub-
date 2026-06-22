
--
-- PostgreSQL database dump
--

\restrict O8D1myO7RS2IzSJEitXVRzQgP67MfOCn4VsZPAnyFRNW7iZ1MZWseTTyDgjnqRI

-- Dumped from database version 17.10
-- Dumped by pg_dump version 17.10

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: drizzle; Type: SCHEMA; Schema: -; Owner: fims_dev
--

CREATE SCHEMA drizzle;


ALTER SCHEMA drizzle OWNER TO fims_dev;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __drizzle_migrations; Type: TABLE; Schema: drizzle; Owner: fims_dev
--

CREATE TABLE drizzle.__drizzle_migrations (
    id integer NOT NULL,
    hash text NOT NULL,
    created_at bigint
);


ALTER TABLE drizzle.__drizzle_migrations OWNER TO fims_dev;

--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE; Schema: drizzle; Owner: fims_dev
--

CREATE SEQUENCE drizzle.__drizzle_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNER TO fims_dev;

--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: drizzle; Owner: fims_dev
--

ALTER SEQUENCE drizzle.__drizzle_migrations_id_seq OWNED BY drizzle.__drizzle_migrations.id;


--
-- Name: academic_semester; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.academic_semester (
    id integer NOT NULL,
    semester_number smallint NOT NULL,
    academic_year integer NOT NULL
);


ALTER TABLE public.academic_semester OWNER TO fims_dev;

--
-- Name: academic_semester_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.academic_semester_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.academic_semester_id_seq OWNER TO fims_dev;

--
-- Name: academic_semester_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.academic_semester_id_seq OWNED BY public.academic_semester.id;


--
-- Name: account; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.account (
    id text NOT NULL,
    account_id text NOT NULL,
    provider_id text NOT NULL,
    user_id text NOT NULL,
    access_token text,
    refresh_token text,
    id_token text,
    access_token_expires_at timestamp without time zone,
    refresh_token_expires_at timestamp without time zone,
    scope text,
    password text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.account OWNER TO fims_dev;

--
-- Name: changelog; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.changelog (
    id integer NOT NULL,
    "timestamp" timestamp without time zone DEFAULT now() NOT NULL,
    operator_id text,
    tuple_id integer,
    operation text NOT NULL
);


ALTER TABLE public.changelog OWNER TO fims_dev;

--
-- Name: profile; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.profile (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    email_verified boolean DEFAULT false NOT NULL,
    image text,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    role text,
    banned boolean DEFAULT false,
    ban_reason text,
    ban_expires timestamp without time zone
);


ALTER TABLE public.profile OWNER TO fims_dev;

--
-- Name: profile_info; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.profile_info (
    id integer NOT NULL,
    profile_id text NOT NULL,
    role character varying(50) NOT NULL,
    latest_changelog_id integer
);


ALTER TABLE public.profile_info OWNER TO fims_dev;

--
-- Name: account_search_view; Type: MATERIALIZED VIEW; Schema: public; Owner: fims_dev
--

CREATE MATERIALIZED VIEW public.account_search_view AS
 SELECT profile.id,
    ((((((((COALESCE(profile.email, ''::text) || ' '::text) || (COALESCE(profile_info.role, ''::character varying))::text) || ' '::text) || COALESCE((changelog_sq."timestamp")::text, ''::text)) || ' '::text) || COALESCE(changelog_sq.email, ''::text)) || ' '::text) || COALESCE(changelog_sq.operation, ''::text)) AS search_content
   FROM ((public.profile
     LEFT JOIN public.profile_info ON ((profile_info.profile_id = profile.id)))
     LEFT JOIN ( SELECT changelog.id,
            changelog."timestamp",
            profile_1.email,
            changelog.operation
           FROM (public.changelog
             LEFT JOIN public.profile profile_1 ON ((profile_1.id = changelog.operator_id)))) changelog_sq ON ((changelog_sq.id = profile_info.latest_changelog_id)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.account_search_view OWNER TO fims_dev;

--
-- Name: admin_position; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.admin_position (
    id integer NOT NULL,
    title character varying(100) NOT NULL
);


ALTER TABLE public.admin_position OWNER TO fims_dev;

--
-- Name: admin_position_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.admin_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.admin_position_id_seq OWNER TO fims_dev;

--
-- Name: admin_position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.admin_position_id_seq OWNED BY public.admin_position.id;


--
-- Name: appointment_status; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.appointment_status (
    appointment_status character varying(50) NOT NULL
);


ALTER TABLE public.appointment_status OWNER TO fims_dev;

--
-- Name: changelog_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.changelog_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.changelog_id_seq OWNER TO fims_dev;

--
-- Name: changelog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.changelog_id_seq OWNED BY public.changelog.id;


--
-- Name: course; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.course (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    units integer NOT NULL,
    degree_program_id integer
);


ALTER TABLE public.course OWNER TO fims_dev;

--
-- Name: course_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_id_seq OWNER TO fims_dev;

--
-- Name: course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.course_id_seq OWNED BY public.course.id;


--
-- Name: degree_program; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.degree_program (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    is_graduate_level boolean NOT NULL
);


ALTER TABLE public.degree_program OWNER TO fims_dev;

--
-- Name: degree_program_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.degree_program_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.degree_program_id_seq OWNER TO fims_dev;

--
-- Name: degree_program_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.degree_program_id_seq OWNED BY public.degree_program.id;


--
-- Name: faculty; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty (
    id integer NOT NULL,
    last_name character varying(100) NOT NULL,
    middle_name character varying(100) NOT NULL,
    first_name character varying(100) NOT NULL,
    suffix character varying(50),
    maiden_name character varying(100),
    birth_date date NOT NULL,
    status character varying(50),
    date_of_original_appointment date NOT NULL,
    psi_item character varying(50) NOT NULL,
    employee_number character varying(50) NOT NULL,
    tin character varying(50) NOT NULL,
    gsis character varying(50) NOT NULL,
    philhealth character varying(50) NOT NULL,
    pagibig character varying(50) NOT NULL,
    remarks text,
    latest_changelog_id integer,
    biological_sex character(1) NOT NULL,
    CONSTRAINT faculty_biological_sex_check CHECK ((biological_sex = ANY (ARRAY['M'::bpchar, 'F'::bpchar, 'I'::bpchar, 'U'::bpchar])))
);


ALTER TABLE public.faculty OWNER TO fims_dev;

--
-- Name: faculty_academic_semester; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_academic_semester (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    academic_semester_id integer,
    current_rank_id integer,
    current_highest_educational_attainment_id integer,
    remarks text
);


ALTER TABLE public.faculty_academic_semester OWNER TO fims_dev;

--
-- Name: faculty_academic_semester_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_academic_semester_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_academic_semester_id_seq OWNER TO fims_dev;

--
-- Name: faculty_academic_semester_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_academic_semester_id_seq OWNED BY public.faculty_academic_semester.id;


--
-- Name: faculty_admin_position; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_admin_position (
    id integer NOT NULL,
    faculty_academic_semester_id integer,
    admin_position_id integer,
    office_id integer,
    start_date date NOT NULL,
    end_date date NOT NULL,
    administrative_load_credit numeric(5,2) NOT NULL
);


ALTER TABLE public.faculty_admin_position OWNER TO fims_dev;

--
-- Name: faculty_admin_position_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_admin_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_admin_position_id_seq OWNER TO fims_dev;

--
-- Name: faculty_admin_position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_admin_position_id_seq OWNED BY public.faculty_admin_position.id;


--
-- Name: faculty_admin_work; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_admin_work (
    id integer NOT NULL,
    faculty_academic_semester_id integer,
    nature_of_work character varying(200) NOT NULL,
    office_id integer,
    start_date date NOT NULL,
    end_date date NOT NULL,
    administrative_load_credit numeric(5,2) NOT NULL
);


ALTER TABLE public.faculty_admin_work OWNER TO fims_dev;

--
-- Name: faculty_admin_work_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_admin_work_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_admin_work_id_seq OWNER TO fims_dev;

--
-- Name: faculty_admin_work_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_admin_work_id_seq OWNED BY public.faculty_admin_work.id;


--
-- Name: faculty_comm_membership; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_comm_membership (
    id integer NOT NULL,
    faculty_academic_semester_id integer,
    membership character varying(100) NOT NULL,
    committee character varying(150) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    administrative_load_credit numeric(5,2) NOT NULL
);


ALTER TABLE public.faculty_comm_membership OWNER TO fims_dev;

--
-- Name: faculty_comm_membership_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_comm_membership_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_comm_membership_id_seq OWNER TO fims_dev;

--
-- Name: faculty_comm_membership_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_comm_membership_id_seq OWNED BY public.faculty_comm_membership.id;


--
-- Name: faculty_contact_number; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_contact_number (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    contact_number character varying(20) NOT NULL
);


ALTER TABLE public.faculty_contact_number OWNER TO fims_dev;

--
-- Name: faculty_contact_number_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_contact_number_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_contact_number_id_seq OWNER TO fims_dev;

--
-- Name: faculty_contact_number_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_contact_number_id_seq OWNED BY public.faculty_contact_number.id;


--
-- Name: faculty_course; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_course (
    id integer NOT NULL,
    faculty_academic_semester_id integer,
    course_id integer,
    section character varying(50),
    number_of_students integer,
    teaching_load_credit numeric(5,2) NOT NULL,
    section_set numeric(4,3)
);


ALTER TABLE public.faculty_course OWNER TO fims_dev;

--
-- Name: faculty_course_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_course_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_course_id_seq OWNER TO fims_dev;

--
-- Name: faculty_course_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_course_id_seq OWNED BY public.faculty_course.id;


--
-- Name: faculty_educational_attainment; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_educational_attainment (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    degree character varying(100) NOT NULL,
    institution character varying(200) NOT NULL,
    graduation_year integer
);


ALTER TABLE public.faculty_educational_attainment OWNER TO fims_dev;

--
-- Name: faculty_educational_attainment_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_educational_attainment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_educational_attainment_id_seq OWNER TO fims_dev;

--
-- Name: faculty_educational_attainment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_educational_attainment_id_seq OWNED BY public.faculty_educational_attainment.id;


--
-- Name: faculty_email; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_email (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    email character varying(100) NOT NULL
);


ALTER TABLE public.faculty_email OWNER TO fims_dev;

--
-- Name: faculty_email_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_email_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_email_id_seq OWNER TO fims_dev;

--
-- Name: faculty_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_email_id_seq OWNED BY public.faculty_email.id;


--
-- Name: faculty_extension; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_extension (
    id integer NOT NULL,
    faculty_academic_semester_id integer,
    nature_of_extension character varying(200) NOT NULL,
    agency character varying(150) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    extension_load_credit numeric(5,2) NOT NULL
);


ALTER TABLE public.faculty_extension OWNER TO fims_dev;

--
-- Name: faculty_extension_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_extension_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_extension_id_seq OWNER TO fims_dev;

--
-- Name: faculty_extension_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_extension_id_seq OWNED BY public.faculty_extension.id;


--
-- Name: faculty_field_of_interest; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_field_of_interest (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    field_of_interest_id integer NOT NULL
);


ALTER TABLE public.faculty_field_of_interest OWNER TO fims_dev;

--
-- Name: faculty_field_of_interest_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_field_of_interest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_field_of_interest_id_seq OWNER TO fims_dev;

--
-- Name: faculty_field_of_interest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_field_of_interest_id_seq OWNED BY public.faculty_field_of_interest.id;


--
-- Name: faculty_home_address; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_home_address (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    home_address text NOT NULL
);


ALTER TABLE public.faculty_home_address OWNER TO fims_dev;

--
-- Name: faculty_home_address_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_home_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_home_address_id_seq OWNER TO fims_dev;

--
-- Name: faculty_home_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_home_address_id_seq OWNED BY public.faculty_home_address.id;


--
-- Name: faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_id_seq OWNER TO fims_dev;

--
-- Name: faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_id_seq OWNED BY public.faculty.id;


--
-- Name: faculty_mentoring; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_mentoring (
    id integer NOT NULL,
    faculty_academic_semester_id integer,
    student_id integer,
    category character varying(50),
    start_date date NOT NULL,
    end_date date NOT NULL,
    remarks text
);


ALTER TABLE public.faculty_mentoring OWNER TO fims_dev;

--
-- Name: faculty_mentoring_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_mentoring_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_mentoring_id_seq OWNER TO fims_dev;

--
-- Name: faculty_mentoring_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_mentoring_id_seq OWNED BY public.faculty_mentoring.id;


--
-- Name: faculty_rank; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_rank (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    rank_id integer,
    appointment_status character varying(50),
    date_of_tenure_or_renewal date NOT NULL
);


ALTER TABLE public.faculty_rank OWNER TO fims_dev;

--
-- Name: faculty_rank_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_rank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_rank_id_seq OWNER TO fims_dev;

--
-- Name: faculty_rank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_rank_id_seq OWNED BY public.faculty_rank.id;


--
-- Name: faculty_research; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_research (
    id integer NOT NULL,
    faculty_academic_semester_id integer,
    research_id integer,
    research_load_credit numeric(5,2) NOT NULL,
    remarks text
);


ALTER TABLE public.faculty_research OWNER TO fims_dev;

--
-- Name: faculty_study_load; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.faculty_study_load (
    id integer NOT NULL,
    faculty_academic_semester_id integer,
    degree_program character varying(200) NOT NULL,
    university character varying(150) NOT NULL,
    study_load_units numeric(5,2) NOT NULL,
    on_full_time_leave_with_pay boolean NOT NULL,
    is_faculty_fellowship_recipient boolean NOT NULL,
    study_load_credit numeric(5,2) NOT NULL
);


ALTER TABLE public.faculty_study_load OWNER TO fims_dev;

--
-- Name: field_of_interest; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.field_of_interest (
    id integer NOT NULL,
    field character varying(100) NOT NULL
);


ALTER TABLE public.field_of_interest OWNER TO fims_dev;

--
-- Name: office; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.office (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE public.office OWNER TO fims_dev;

--
-- Name: rank; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.rank (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    salary_grade character varying(10) NOT NULL,
    salary_rate numeric(10,2) NOT NULL
);


ALTER TABLE public.rank OWNER TO fims_dev;

--
-- Name: research; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.research (
    id integer NOT NULL,
    title character varying(200) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    funding text
);


ALTER TABLE public.research OWNER TO fims_dev;

--
-- Name: status; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.status (
    status character varying(50) NOT NULL
);


ALTER TABLE public.status OWNER TO fims_dev;

--
-- Name: student; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.student (
    id integer NOT NULL,
    last_name character varying(100) NOT NULL,
    middle_name character varying(100) NOT NULL,
    first_name character varying(100) NOT NULL
);


ALTER TABLE public.student OWNER TO fims_dev;

--
-- Name: faculty_record_search_view; Type: MATERIALIZED VIEW; Schema: public; Owner: fims_dev
--

CREATE MATERIALIZED VIEW public.faculty_record_search_view AS
 SELECT faculty.id,
    (((((((((((((COALESCE(faculty.last_name, ''::character varying))::text || ' '::text) || (COALESCE(faculty.middle_name, ''::character varying))::text) || ' '::text) || (COALESCE(faculty.first_name, ''::character varying))::text) || ' '::text) || (COALESCE(faculty.suffix, ''::character varying))::text) || ' '::text) || COALESCE((faculty.birth_date)::text, ''::text)) || ' '::text) || (COALESCE(status.status, ''::character varying))::text) || ' '::text) || COALESCE((faculty.date_of_original_appointment)::text, ''::text)) AS searchcontent
   FROM (public.faculty
     LEFT JOIN public.status ON (((faculty.status)::text = (status.status)::text)))
UNION
 SELECT faculty_educational_attainment.faculty_id AS id,
    (((((COALESCE(faculty_educational_attainment.degree, ''::character varying))::text || ' '::text) || (COALESCE(faculty_educational_attainment.institution, ''::character varying))::text) || ' '::text) || COALESCE((faculty_educational_attainment.graduation_year)::text, ''::text)) AS searchcontent
   FROM public.faculty_educational_attainment
UNION
 SELECT faculty_field_of_interest.faculty_id AS id,
    COALESCE(field_of_interest.field, ''::character varying) AS searchcontent
   FROM (public.faculty_field_of_interest
     LEFT JOIN public.field_of_interest ON ((faculty_field_of_interest.field_of_interest_id = field_of_interest.id)))
UNION
 SELECT faculty_rank.faculty_id AS id,
    (((((((((COALESCE(rank.title, ''::character varying))::text || ' '::text) || (COALESCE(rank.salary_grade, ''::character varying))::text) || ' '::text) || COALESCE((rank.salary_rate)::text, ''::text)) || ' '::text) || (COALESCE(faculty_rank.appointment_status, ''::character varying))::text) || ' '::text) || COALESCE((faculty_rank.date_of_tenure_or_renewal)::text, ''::text)) AS searchcontent
   FROM (public.faculty_rank
     LEFT JOIN public.rank ON ((faculty_rank.rank_id = rank.id)))
UNION
 SELECT faculty_email.faculty_id AS id,
    COALESCE(faculty_email.email, ''::character varying) AS searchcontent
   FROM public.faculty_email
UNION
 SELECT faculty_academic_semester.faculty_id AS id,
    (((((((COALESCE(admin_position.title, ''::character varying))::text || ' '::text) || (COALESCE(office.name, ''::character varying))::text) || ' '::text) || COALESCE((faculty_admin_position.start_date)::text, ''::text)) || ' '::text) || COALESCE((faculty_admin_position.end_date)::text, ''::text)) AS searchcontent
   FROM (((public.faculty_academic_semester
     LEFT JOIN public.faculty_admin_position ON ((faculty_academic_semester.id = faculty_admin_position.faculty_academic_semester_id)))
     LEFT JOIN public.admin_position ON ((faculty_admin_position.admin_position_id = admin_position.id)))
     LEFT JOIN public.office ON ((faculty_admin_position.office_id = office.id)))
UNION
 SELECT faculty_academic_semester.faculty_id AS id,
    (((((((COALESCE(faculty_comm_membership.membership, ''::character varying))::text || ' '::text) || (COALESCE(faculty_comm_membership.committee, ''::character varying))::text) || ' '::text) || COALESCE((faculty_comm_membership.start_date)::text, ''::text)) || ' '::text) || COALESCE((faculty_comm_membership.end_date)::text, ''::text)) AS searchcontent
   FROM (public.faculty_academic_semester
     LEFT JOIN public.faculty_comm_membership ON ((faculty_academic_semester.id = faculty_comm_membership.faculty_academic_semester_id)))
UNION
 SELECT faculty_academic_semester.faculty_id AS id,
    (((((((COALESCE(faculty_admin_work.nature_of_work, ''::character varying))::text || ' '::text) || (COALESCE(office.name, ''::character varying))::text) || ' '::text) || COALESCE((faculty_admin_work.start_date)::text, ''::text)) || ' '::text) || COALESCE((faculty_admin_work.end_date)::text, ''::text)) AS searchcontent
   FROM ((public.faculty_academic_semester
     LEFT JOIN public.faculty_admin_work ON ((faculty_academic_semester.id = faculty_admin_work.faculty_academic_semester_id)))
     LEFT JOIN public.office ON ((faculty_admin_work.office_id = office.id)))
UNION
 SELECT faculty_academic_semester.faculty_id AS id,
    (((((COALESCE(course.name, ''::character varying))::text || ' '::text) || (COALESCE(faculty_course.section, ''::character varying))::text) || ' '::text) || COALESCE((faculty_course.number_of_students)::text, ''::text)) AS searchcontent
   FROM ((public.faculty_academic_semester
     LEFT JOIN public.faculty_course ON ((faculty_academic_semester.id = faculty_course.faculty_academic_semester_id)))
     LEFT JOIN public.course ON ((faculty_course.course_id = course.id)))
UNION
 SELECT faculty_academic_semester.faculty_id AS id,
    ((((((((((((((COALESCE((student.id)::text, ''::text) || ' '::text) || (COALESCE(student.last_name, ''::character varying))::text) || ' '::text) || (COALESCE(student.middle_name, ''::character varying))::text) || ' '::text) || (COALESCE(student.first_name, ''::character varying))::text) || ' '::text) || (COALESCE(faculty_mentoring.category, ''::character varying))::text) || ' '::text) || COALESCE((faculty_mentoring.start_date)::text, ''::text)) || ' '::text) || COALESCE((faculty_mentoring.end_date)::text, ''::text)) || ' '::text) || COALESCE(faculty_mentoring.remarks, ''::text)) AS searchcontent
   FROM ((public.faculty_academic_semester
     LEFT JOIN public.faculty_mentoring ON ((faculty_academic_semester.id = faculty_mentoring.faculty_academic_semester_id)))
     LEFT JOIN public.student ON ((faculty_mentoring.student_id = student.id)))
UNION
 SELECT faculty_academic_semester.faculty_id AS id,
    (((((((COALESCE(research.title, ''::character varying))::text || ' '::text) || COALESCE((research.start_date)::text, ''::text)) || ' '::text) || COALESCE((research.end_date)::text, ''::text)) || ' '::text) || COALESCE(research.funding, ''::text)) AS searchcontent
   FROM ((public.faculty_academic_semester
     LEFT JOIN public.faculty_research ON ((faculty_academic_semester.id = faculty_research.faculty_academic_semester_id)))
     LEFT JOIN public.research ON ((faculty_research.research_id = research.id)))
UNION
 SELECT faculty_academic_semester.faculty_id AS id,
    (((((((COALESCE(faculty_extension.nature_of_extension, ''::character varying))::text || ' '::text) || (COALESCE(faculty_extension.agency, ''::character varying))::text) || ' '::text) || COALESCE((faculty_extension.start_date)::text, ''::text)) || ' '::text) || COALESCE((faculty_extension.end_date)::text, ''::text)) AS searchcontent
   FROM (public.faculty_academic_semester
     LEFT JOIN public.faculty_extension ON ((faculty_academic_semester.id = faculty_extension.faculty_academic_semester_id)))
UNION
 SELECT faculty_academic_semester.faculty_id AS id,
    (((COALESCE(faculty_study_load.degree_program, ''::character varying))::text || ' '::text) || (COALESCE(faculty_study_load.university, ''::character varying))::text) AS searchcontent
   FROM (public.faculty_academic_semester
     LEFT JOIN public.faculty_study_load ON ((faculty_academic_semester.id = faculty_study_load.faculty_academic_semester_id)))
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.faculty_record_search_view OWNER TO fims_dev;

--
-- Name: faculty_research_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_research_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_research_id_seq OWNER TO fims_dev;

--
-- Name: faculty_research_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_research_id_seq OWNED BY public.faculty_research.id;


--
-- Name: faculty_study_load_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.faculty_study_load_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_study_load_id_seq OWNER TO fims_dev;

--
-- Name: faculty_study_load_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.faculty_study_load_id_seq OWNED BY public.faculty_study_load.id;


--
-- Name: field_of_interest_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.field_of_interest_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.field_of_interest_id_seq OWNER TO fims_dev;

--
-- Name: field_of_interest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.field_of_interest_id_seq OWNED BY public.field_of_interest.id;


--
-- Name: office_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.office_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.office_id_seq OWNER TO fims_dev;

--
-- Name: office_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.office_id_seq OWNED BY public.office.id;


--
-- Name: profile_info_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.profile_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.profile_info_id_seq OWNER TO fims_dev;

--
-- Name: profile_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.profile_info_id_seq OWNED BY public.profile_info.id;


--
-- Name: rank_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.rank_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rank_id_seq OWNER TO fims_dev;

--
-- Name: rank_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.rank_id_seq OWNED BY public.rank.id;


--
-- Name: research_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.research_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.research_id_seq OWNER TO fims_dev;

--
-- Name: research_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.research_id_seq OWNED BY public.research.id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.role (
    role character varying(50) NOT NULL,
    can_add_faculty boolean NOT NULL,
    can_modify_faculty boolean NOT NULL,
    can_add_account boolean NOT NULL,
    can_modify_account boolean NOT NULL,
    can_view_changelogs boolean NOT NULL
);


ALTER TABLE public.role OWNER TO fims_dev;

--
-- Name: session; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.session (
    id text NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    token text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ip_address text,
    user_agent text,
    user_id text NOT NULL,
    impersonated_by text
);


ALTER TABLE public.session OWNER TO fims_dev;

--
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: fims_dev
--

CREATE SEQUENCE public.student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_id_seq OWNER TO fims_dev;

--
-- Name: student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: fims_dev
--

ALTER SEQUENCE public.student_id_seq OWNED BY public.student.id;


--
-- Name: verification; Type: TABLE; Schema: public; Owner: fims_dev
--

CREATE TABLE public.verification (
    id text NOT NULL,
    identifier text NOT NULL,
    value text NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.verification OWNER TO fims_dev;

--
-- Name: __drizzle_migrations id; Type: DEFAULT; Schema: drizzle; Owner: fims_dev
--

ALTER TABLE ONLY drizzle.__drizzle_migrations ALTER COLUMN id SET DEFAULT nextval('drizzle.__drizzle_migrations_id_seq'::regclass);


--
-- Name: academic_semester id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.academic_semester ALTER COLUMN id SET DEFAULT nextval('public.academic_semester_id_seq'::regclass);


--
-- Name: admin_position id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.admin_position ALTER COLUMN id SET DEFAULT nextval('public.admin_position_id_seq'::regclass);


--
-- Name: changelog id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.changelog ALTER COLUMN id SET DEFAULT nextval('public.changelog_id_seq'::regclass);


--
-- Name: course id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.course ALTER COLUMN id SET DEFAULT nextval('public.course_id_seq'::regclass);


--
-- Name: degree_program id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.degree_program ALTER COLUMN id SET DEFAULT nextval('public.degree_program_id_seq'::regclass);


--
-- Name: faculty id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty ALTER COLUMN id SET DEFAULT nextval('public.faculty_id_seq'::regclass);


--
-- Name: faculty_academic_semester id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_academic_semester ALTER COLUMN id SET DEFAULT nextval('public.faculty_academic_semester_id_seq'::regclass);


--
-- Name: faculty_admin_position id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_admin_position ALTER COLUMN id SET DEFAULT nextval('public.faculty_admin_position_id_seq'::regclass);


--
-- Name: faculty_admin_work id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_admin_work ALTER COLUMN id SET DEFAULT nextval('public.faculty_admin_work_id_seq'::regclass);


--
-- Name: faculty_comm_membership id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_comm_membership ALTER COLUMN id SET DEFAULT nextval('public.faculty_comm_membership_id_seq'::regclass);


--
-- Name: faculty_contact_number id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_contact_number ALTER COLUMN id SET DEFAULT nextval('public.faculty_contact_number_id_seq'::regclass);


--
-- Name: faculty_course id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_course ALTER COLUMN id SET DEFAULT nextval('public.faculty_course_id_seq'::regclass);


--
-- Name: faculty_educational_attainment id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_educational_attainment ALTER COLUMN id SET DEFAULT nextval('public.faculty_educational_attainment_id_seq'::regclass);


--
-- Name: faculty_email id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_email ALTER COLUMN id SET DEFAULT nextval('public.faculty_email_id_seq'::regclass);


--
-- Name: faculty_extension id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_extension ALTER COLUMN id SET DEFAULT nextval('public.faculty_extension_id_seq'::regclass);


--
-- Name: faculty_field_of_interest id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_field_of_interest ALTER COLUMN id SET DEFAULT nextval('public.faculty_field_of_interest_id_seq'::regclass);


--
-- Name: faculty_home_address id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_home_address ALTER COLUMN id SET DEFAULT nextval('public.faculty_home_address_id_seq'::regclass);


--
-- Name: faculty_mentoring id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_mentoring ALTER COLUMN id SET DEFAULT nextval('public.faculty_mentoring_id_seq'::regclass);


--
-- Name: faculty_rank id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_rank ALTER COLUMN id SET DEFAULT nextval('public.faculty_rank_id_seq'::regclass);


--
-- Name: faculty_research id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_research ALTER COLUMN id SET DEFAULT nextval('public.faculty_research_id_seq'::regclass);


--
-- Name: faculty_study_load id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_study_load ALTER COLUMN id SET DEFAULT nextval('public.faculty_study_load_id_seq'::regclass);


--
-- Name: field_of_interest id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.field_of_interest ALTER COLUMN id SET DEFAULT nextval('public.field_of_interest_id_seq'::regclass);


--
-- Name: office id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.office ALTER COLUMN id SET DEFAULT nextval('public.office_id_seq'::regclass);


--
-- Name: profile_info id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.profile_info ALTER COLUMN id SET DEFAULT nextval('public.profile_info_id_seq'::regclass);


--
-- Name: rank id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.rank ALTER COLUMN id SET DEFAULT nextval('public.rank_id_seq'::regclass);


--
-- Name: research id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.research ALTER COLUMN id SET DEFAULT nextval('public.research_id_seq'::regclass);


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_id_seq'::regclass);


--
-- Data for Name: __drizzle_migrations; Type: TABLE DATA; Schema: drizzle; Owner: fims_dev
--

COPY drizzle.__drizzle_migrations (id, hash, created_at) FROM stdin;
1	8fe96a16797e18483478dd11826b7021640947288c5fbb8805d47402676745cb	1775508040413
2	0b51e77108eae21034dbf217f131ef318f4ccce6e96b2558f4d024e17c311107	1775510485674
3	df2062ee6019f150a2ac528a68a33e0feecd38fee6cf3921a41455f9dafcdf66	1775510657389
4	f8f031c96465dc3b3e5b750e7deec4d50a606667c2a911622a6477a345de0e1f	1775510707101
5	6a5753b873043d8eb527731f2761ccd32abfbf5a02dc52868af0dfeb7df95238	1775511364251
6	d0ea12c80fd8206960f48a8af18b07dec06f935ef106ae07628e540603193c82	1775525376218
7	9162cc9551a1e07b4ff6d939aa1cdad55527d2cbc467fb9cdaab89eba01315c9	1776002395842
8	fa9e704a114faa04ecfc269f3bb93ac974fe283aa4dc60786970f950cb82b566	1776003019858
9	9bb160cb35ac2f8828dfd55374a51e0e60b35cea811ecf0e62ac4b6fbeb68623	1776273036770
\.


--
-- Data for Name: academic_semester; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.academic_semester (id, semester_number, academic_year) FROM stdin;
\.


--
-- Data for Name: account; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.account (id, account_id, provider_id, user_id, access_token, refresh_token, id_token, access_token_expires_at, refresh_token_expires_at, scope, password, created_at, updated_at) FROM stdin;
j67i3j8SdixXJoRmJlVM1BdX6LE2G1jP	AHrr85z658tOnVEsZ6lvKbDscKUGsPoT	credential	AHrr85z658tOnVEsZ6lvKbDscKUGsPoT	\N	\N	\N	\N	\N	\N	ef35937e83fb2b9f8b2fbb8dda90fab4:53f96c8865a1f3fdd802674feafd1362a2188e04a4653ab60da1beb9c71bdfe88e0b4863ee18fec1c35a18e069d417b8002e827afad7f58d7900521717448f93	2026-06-17 14:04:57.539	2026-06-17 14:04:57.539
yx1HlFKd9oNo9kfvYXdMVWia1IUUArWi	arA6eNFuT9LtrgPGcCoQM2ugzB0IkqVr	credential	arA6eNFuT9LtrgPGcCoQM2ugzB0IkqVr	\N	\N	\N	\N	\N	\N	5c0ed3bfdf02dc875d378e355608779d:785cf98b281824a1679ca43ba154b107c9d9b10b27327327c704e0cf2a01e41e74c4bc8aa680afbd694d926e4d0137c744b4bb852a8a982eeb7eef700c0d7fa2	2026-06-17 14:04:57.895	2026-06-17 14:04:57.895
\.


--
-- Data for Name: admin_position; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.admin_position (id, title) FROM stdin;
1	Department Chair
2	Assistant Chair for Student Affairs
3	Assistant Chair for Linkages and Partnerships
\.


--
-- Data for Name: appointment_status; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.appointment_status (appointment_status) FROM stdin;
Permanent
Full-Time
Temporary
Part-Time
\.


--
-- Data for Name: changelog; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.changelog (id, "timestamp", operator_id, tuple_id, operation) FROM stdin;
\.


--
-- Data for Name: course; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.course (id, name, units, degree_program_id) FROM stdin;
1	Econ 11	3	1
2	CS 11	3	1
3	CS 12	3	1
4	CS 32	3	1
5	CS 33	3	1
6	CS 191	3	1
7	CS 192	3	1
8	CS 195	3	1
9	CS 200	3	2
10	CS 211	3	2
11	DE 100	3	3
12	DE 236	3	3
\.


--
-- Data for Name: degree_program; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.degree_program (id, name, is_graduate_level) FROM stdin;
1	Undergraduate	f
2	MA/PhD	t
3	MDE	t
\.


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty (id, last_name, middle_name, first_name, suffix, maiden_name, birth_date, status, date_of_original_appointment, psi_item, employee_number, tin, gsis, philhealth, pagibig, remarks, latest_changelog_id, biological_sex) FROM stdin;
\.


--
-- Data for Name: faculty_academic_semester; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_academic_semester (id, faculty_id, academic_semester_id, current_rank_id, current_highest_educational_attainment_id, remarks) FROM stdin;
\.


--
-- Data for Name: faculty_admin_position; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_admin_position (id, faculty_academic_semester_id, admin_position_id, office_id, start_date, end_date, administrative_load_credit) FROM stdin;
\.


--
-- Data for Name: faculty_admin_work; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_admin_work (id, faculty_academic_semester_id, nature_of_work, office_id, start_date, end_date, administrative_load_credit) FROM stdin;
\.


--
-- Data for Name: faculty_comm_membership; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_comm_membership (id, faculty_academic_semester_id, membership, committee, start_date, end_date, administrative_load_credit) FROM stdin;
\.


--
-- Data for Name: faculty_contact_number; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_contact_number (id, faculty_id, contact_number) FROM stdin;
\.


--
-- Data for Name: faculty_course; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_course (id, faculty_academic_semester_id, course_id, section, number_of_students, teaching_load_credit, section_set) FROM stdin;
\.


--
-- Data for Name: faculty_educational_attainment; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_educational_attainment (id, faculty_id, degree, institution, graduation_year) FROM stdin;
\.


--
-- Data for Name: faculty_email; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_email (id, faculty_id, email) FROM stdin;
\.


--
-- Data for Name: faculty_extension; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_extension (id, faculty_academic_semester_id, nature_of_extension, agency, start_date, end_date, extension_load_credit) FROM stdin;
\.


--
-- Data for Name: faculty_field_of_interest; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_field_of_interest (id, faculty_id, field_of_interest_id) FROM stdin;
\.


--
-- Data for Name: faculty_home_address; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_home_address (id, faculty_id, home_address) FROM stdin;
\.


--
-- Data for Name: faculty_mentoring; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_mentoring (id, faculty_academic_semester_id, student_id, category, start_date, end_date, remarks) FROM stdin;
\.


--
-- Data for Name: faculty_rank; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_rank (id, faculty_id, rank_id, appointment_status, date_of_tenure_or_renewal) FROM stdin;
\.


--
-- Data for Name: faculty_research; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_research (id, faculty_academic_semester_id, research_id, research_load_credit, remarks) FROM stdin;
\.


--
-- Data for Name: faculty_study_load; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.faculty_study_load (id, faculty_academic_semester_id, degree_program, university, study_load_units, on_full_time_leave_with_pay, is_faculty_fellowship_recipient, study_load_credit) FROM stdin;
\.


--
-- Data for Name: field_of_interest; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.field_of_interest (id, field) FROM stdin;
1	Software Engineering
2	Data Science
3	Artificial Intelligence
4	Cybersecurity
5	Information Systems
\.


--
-- Data for Name: office; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.office (id, name) FROM stdin;
1	Department of Computer Science
2	College of Engineering
3	Office of the Vice Chancellor for Student Affairs
\.


--
-- Data for Name: profile; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.profile (id, name, email, email_verified, image, created_at, updated_at, role, banned, ban_reason, ban_expires) FROM stdin;
AHrr85z658tOnVEsZ6lvKbDscKUGsPoT	Admin	admin@up.edu.ph	f	\N	2026-06-17 14:04:57.067	2026-06-17 14:04:57.067	user	f	\N	\N
arA6eNFuT9LtrgPGcCoQM2ugzB0IkqVr	IT	it@up.edu.ph	f	\N	2026-06-17 14:04:57.555	2026-06-17 14:04:57.555	admin	f	\N	\N
\.


--
-- Data for Name: profile_info; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.profile_info (id, profile_id, role, latest_changelog_id) FROM stdin;
1	AHrr85z658tOnVEsZ6lvKbDscKUGsPoT	Admin	\N
2	arA6eNFuT9LtrgPGcCoQM2ugzB0IkqVr	IT	\N
\.


--
-- Data for Name: rank; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.rank (id, title, salary_grade, salary_rate) FROM stdin;
1	Instructor 1	14-1	500000.00
2	Instructor 2	15-1	500000.00
3	Instructor 3	15-3	500000.00
4	Instructor 4	16-1	500000.00
5	Instructor 5	16-3	500000.00
6	Instructor 6	17-1	500000.00
7	Instructor 7	17-3	500000.00
8	Assistant Professor 1	18-1	500000.00
9	Assistant Professor 2	19-1	500000.00
10	Assistant Professor 3	19-3	500000.00
11	Assistant Professor 4	20-1	500000.00
12	Assistant Professor 5	21-1	500000.00
13	Assistant Professor 6	21-3	500000.00
14	Assistant Professor 7	21-5	500000.00
15	Associate Professor 1	22-4	500000.00
16	Associate Professor 2	22-5	500000.00
17	Associate Professor 3	23-4	500000.00
18	Associate Professor 4	24-3	500000.00
19	Associate Professor 5	25-2	500000.00
20	Associate Professor 6	25-3	500000.00
21	Associate Professor 7	25-5	500000.00
22	Professor 1	26-4	500000.00
23	Professor 2	26-5	500000.00
24	Professor 3	26-6	500000.00
25	Professor 4	27-5	500000.00
26	Professor 5	27-6	500000.00
27	Professor 6	27-7	500000.00
28	Professor 7	28-6	500000.00
29	Professor 8	28-7	500000.00
30	Professor 9	28-8	500000.00
31	Professor 10	29-7	500000.00
32	Professor 11	29-8	500000.00
33	Professor 12	29-8	500000.00
\.


--
-- Data for Name: research; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.research (id, title, start_date, end_date, funding) FROM stdin;
1	Project BUHAY	2020-12-25	2021-03-12	\N
2	Project NOAH	2023-08-23	2025-04-09	\N
\.


--
-- Data for Name: role; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.role (role, can_add_faculty, can_modify_faculty, can_add_account, can_modify_account, can_view_changelogs) FROM stdin;
Admin	t	t	f	f	f
IT	t	t	t	t	t
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.session (id, expires_at, token, created_at, updated_at, ip_address, user_agent, user_id, impersonated_by) FROM stdin;
\.


--
-- Data for Name: status; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.status (status) FROM stdin;
Active
On Leave
Sabbatical
On Secondment
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.student (id, last_name, middle_name, first_name) FROM stdin;
\.


--
-- Data for Name: verification; Type: TABLE DATA; Schema: public; Owner: fims_dev
--

COPY public.verification (id, identifier, value, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Name: __drizzle_migrations_id_seq; Type: SEQUENCE SET; Schema: drizzle; Owner: fims_dev
--

SELECT pg_catalog.setval('drizzle.__drizzle_migrations_id_seq', 9, true);


--
-- Name: academic_semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.academic_semester_id_seq', 1, false);


--
-- Name: admin_position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.admin_position_id_seq', 3, true);


--
-- Name: changelog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.changelog_id_seq', 1, false);


--
-- Name: course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.course_id_seq', 12, true);


--
-- Name: degree_program_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.degree_program_id_seq', 1, false);


--
-- Name: faculty_academic_semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_academic_semester_id_seq', 1, false);


--
-- Name: faculty_admin_position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_admin_position_id_seq', 1, false);


--
-- Name: faculty_admin_work_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_admin_work_id_seq', 1, false);


--
-- Name: faculty_comm_membership_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_comm_membership_id_seq', 1, false);


--
-- Name: faculty_contact_number_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_contact_number_id_seq', 1, false);


--
-- Name: faculty_course_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_course_id_seq', 1, false);


--
-- Name: faculty_educational_attainment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_educational_attainment_id_seq', 1, false);


--
-- Name: faculty_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_email_id_seq', 1, false);


--
-- Name: faculty_extension_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_extension_id_seq', 1, false);


--
-- Name: faculty_field_of_interest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_field_of_interest_id_seq', 1, false);


--
-- Name: faculty_home_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_home_address_id_seq', 1, false);


--
-- Name: faculty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_id_seq', 1, false);


--
-- Name: faculty_mentoring_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_mentoring_id_seq', 1, false);


--
-- Name: faculty_rank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_rank_id_seq', 1, false);


--
-- Name: faculty_research_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_research_id_seq', 1, false);


--
-- Name: faculty_study_load_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.faculty_study_load_id_seq', 1, false);


--
-- Name: field_of_interest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.field_of_interest_id_seq', 5, true);


--
-- Name: office_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.office_id_seq', 3, true);


--
-- Name: profile_info_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.profile_info_id_seq', 2, true);


--
-- Name: rank_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.rank_id_seq', 1, false);


--
-- Name: research_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.research_id_seq', 2, true);


--
-- Name: student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: fims_dev
--

SELECT pg_catalog.setval('public.student_id_seq', 1, false);


--
-- Name: __drizzle_migrations __drizzle_migrations_pkey; Type: CONSTRAINT; Schema: drizzle; Owner: fims_dev
--

ALTER TABLE ONLY drizzle.__drizzle_migrations
    ADD CONSTRAINT __drizzle_migrations_pkey PRIMARY KEY (id);


--
-- Name: academic_semester academic_semester_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.academic_semester
    ADD CONSTRAINT academic_semester_pkey PRIMARY KEY (id);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: admin_position admin_position_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.admin_position
    ADD CONSTRAINT admin_position_pkey PRIMARY KEY (id);


--
-- Name: appointment_status appointment_status_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.appointment_status
    ADD CONSTRAINT appointment_status_pkey PRIMARY KEY (appointment_status);


--
-- Name: changelog changelog_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.changelog
    ADD CONSTRAINT changelog_pkey PRIMARY KEY (id);


--
-- Name: course course_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_pkey PRIMARY KEY (id);


--
-- Name: degree_program degree_program_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.degree_program
    ADD CONSTRAINT degree_program_pkey PRIMARY KEY (id);


--
-- Name: faculty_academic_semester faculty_academic_semester_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_academic_semester
    ADD CONSTRAINT faculty_academic_semester_pkey PRIMARY KEY (id);


--
-- Name: faculty_admin_position faculty_admin_position_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_admin_position
    ADD CONSTRAINT faculty_admin_position_pkey PRIMARY KEY (id);


--
-- Name: faculty_admin_work faculty_admin_work_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_admin_work
    ADD CONSTRAINT faculty_admin_work_pkey PRIMARY KEY (id);


--
-- Name: faculty_comm_membership faculty_comm_membership_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_comm_membership
    ADD CONSTRAINT faculty_comm_membership_pkey PRIMARY KEY (id);


--
-- Name: faculty_contact_number faculty_contact_number_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_contact_number
    ADD CONSTRAINT faculty_contact_number_pkey PRIMARY KEY (id);


--
-- Name: faculty_course faculty_course_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_course
    ADD CONSTRAINT faculty_course_pkey PRIMARY KEY (id);


--
-- Name: faculty_educational_attainment faculty_educational_attainment_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_educational_attainment
    ADD CONSTRAINT faculty_educational_attainment_pkey PRIMARY KEY (id);


--
-- Name: faculty_email faculty_email_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_email
    ADD CONSTRAINT faculty_email_pkey PRIMARY KEY (id);


--
-- Name: faculty_extension faculty_extension_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_extension
    ADD CONSTRAINT faculty_extension_pkey PRIMARY KEY (id);


--
-- Name: faculty_field_of_interest faculty_field_of_interest_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_field_of_interest
    ADD CONSTRAINT faculty_field_of_interest_pkey PRIMARY KEY (id);


--
-- Name: faculty_home_address faculty_home_address_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_home_address
    ADD CONSTRAINT faculty_home_address_pkey PRIMARY KEY (id);


--
-- Name: faculty_mentoring faculty_mentoring_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_mentoring
    ADD CONSTRAINT faculty_mentoring_pkey PRIMARY KEY (id);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (id);


--
-- Name: faculty_rank faculty_rank_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_rank
    ADD CONSTRAINT faculty_rank_pkey PRIMARY KEY (id);


--
-- Name: faculty_research faculty_research_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_research
    ADD CONSTRAINT faculty_research_pkey PRIMARY KEY (id);


--
-- Name: faculty_study_load faculty_study_load_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_study_load
    ADD CONSTRAINT faculty_study_load_pkey PRIMARY KEY (id);


--
-- Name: field_of_interest field_of_interest_field_key; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.field_of_interest
    ADD CONSTRAINT field_of_interest_field_key UNIQUE (field);


--
-- Name: field_of_interest field_of_interest_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.field_of_interest
    ADD CONSTRAINT field_of_interest_pkey PRIMARY KEY (id);


--
-- Name: office office_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.office
    ADD CONSTRAINT office_pkey PRIMARY KEY (id);


--
-- Name: profile profile_email_unique; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT profile_email_unique UNIQUE (email);


--
-- Name: profile_info profile_info_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.profile_info
    ADD CONSTRAINT profile_info_pkey PRIMARY KEY (id);


--
-- Name: profile profile_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.profile
    ADD CONSTRAINT profile_pkey PRIMARY KEY (id);


--
-- Name: rank rank_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.rank
    ADD CONSTRAINT rank_pkey PRIMARY KEY (id);


--
-- Name: research research_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.research
    ADD CONSTRAINT research_pkey PRIMARY KEY (id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (role);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: session session_token_unique; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_token_unique UNIQUE (token);


--
-- Name: status status_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.status
    ADD CONSTRAINT status_pkey PRIMARY KEY (status);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- Name: verification verification_pkey; Type: CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.verification
    ADD CONSTRAINT verification_pkey PRIMARY KEY (id);


--
-- Name: account_search_gin_idx; Type: INDEX; Schema: public; Owner: fims_dev
--

CREATE INDEX account_search_gin_idx ON public.account_search_view USING gin (to_tsvector('english'::regconfig, search_content));


--
-- Name: account_userId_idx; Type: INDEX; Schema: public; Owner: fims_dev
--

CREATE INDEX "account_userId_idx" ON public.account USING btree (user_id);


--
-- Name: faculty_record_search_gin_idx; Type: INDEX; Schema: public; Owner: fims_dev
--

CREATE INDEX faculty_record_search_gin_idx ON public.faculty_record_search_view USING gin (to_tsvector('english'::regconfig, searchcontent));


--
-- Name: session_userId_idx; Type: INDEX; Schema: public; Owner: fims_dev
--

CREATE INDEX "session_userId_idx" ON public.session USING btree (user_id);


--
-- Name: verification_identifier_idx; Type: INDEX; Schema: public; Owner: fims_dev
--

CREATE INDEX verification_identifier_idx ON public.verification USING btree (identifier);


--
-- Name: account account_user_id_profile_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_user_id_profile_id_fk FOREIGN KEY (user_id) REFERENCES public.profile(id) ON DELETE CASCADE;


--
-- Name: changelog changelog_operator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.changelog
    ADD CONSTRAINT changelog_operator_id_fkey FOREIGN KEY (operator_id) REFERENCES public.profile(id) ON DELETE SET NULL;


--
-- Name: course course_degree_program_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.course
    ADD CONSTRAINT course_degree_program_id_fkey FOREIGN KEY (degree_program_id) REFERENCES public.degree_program(id) ON DELETE SET NULL;


--
-- Name: faculty_academic_semester faculty_academic_semester_academic_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_academic_semester
    ADD CONSTRAINT faculty_academic_semester_academic_semester_id_fkey FOREIGN KEY (academic_semester_id) REFERENCES public.academic_semester(id) ON DELETE SET NULL;


--
-- Name: faculty_academic_semester faculty_academic_semester_current_highest_educational_attainmen; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_academic_semester
    ADD CONSTRAINT faculty_academic_semester_current_highest_educational_attainmen FOREIGN KEY (current_highest_educational_attainment_id) REFERENCES public.faculty_educational_attainment(id) ON DELETE SET NULL;


--
-- Name: faculty_academic_semester faculty_academic_semester_current_rank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_academic_semester
    ADD CONSTRAINT faculty_academic_semester_current_rank_id_fkey FOREIGN KEY (current_rank_id) REFERENCES public.faculty_rank(id) ON DELETE SET NULL;


--
-- Name: faculty_academic_semester faculty_academic_semester_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_academic_semester
    ADD CONSTRAINT faculty_academic_semester_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id) ON DELETE CASCADE;


--
-- Name: faculty_admin_position faculty_admin_position_admin_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_admin_position
    ADD CONSTRAINT faculty_admin_position_admin_position_id_fkey FOREIGN KEY (admin_position_id) REFERENCES public.admin_position(id) ON DELETE SET NULL;


--
-- Name: faculty_admin_position faculty_admin_position_faculty_academic_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_admin_position
    ADD CONSTRAINT faculty_admin_position_faculty_academic_semester_id_fkey FOREIGN KEY (faculty_academic_semester_id) REFERENCES public.faculty_academic_semester(id) ON DELETE SET NULL;


--
-- Name: faculty_admin_position faculty_admin_position_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_admin_position
    ADD CONSTRAINT faculty_admin_position_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.office(id) ON DELETE SET NULL;


--
-- Name: faculty_admin_work faculty_admin_work_faculty_academic_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_admin_work
    ADD CONSTRAINT faculty_admin_work_faculty_academic_semester_id_fkey FOREIGN KEY (faculty_academic_semester_id) REFERENCES public.faculty_academic_semester(id) ON DELETE SET NULL;


--
-- Name: faculty_admin_work faculty_admin_work_office_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_admin_work
    ADD CONSTRAINT faculty_admin_work_office_id_fkey FOREIGN KEY (office_id) REFERENCES public.office(id) ON DELETE SET NULL;


--
-- Name: faculty_comm_membership faculty_comm_membership_faculty_academic_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_comm_membership
    ADD CONSTRAINT faculty_comm_membership_faculty_academic_semester_id_fkey FOREIGN KEY (faculty_academic_semester_id) REFERENCES public.faculty_academic_semester(id) ON DELETE SET NULL;


--
-- Name: faculty_contact_number faculty_contact_number_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_contact_number
    ADD CONSTRAINT faculty_contact_number_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id) ON DELETE CASCADE;


--
-- Name: faculty_course faculty_course_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_course
    ADD CONSTRAINT faculty_course_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.course(id) ON DELETE SET NULL;


--
-- Name: faculty_course faculty_course_faculty_academic_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_course
    ADD CONSTRAINT faculty_course_faculty_academic_semester_id_fkey FOREIGN KEY (faculty_academic_semester_id) REFERENCES public.faculty_academic_semester(id) ON DELETE SET NULL;


--
-- Name: faculty_educational_attainment faculty_educational_attainment_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_educational_attainment
    ADD CONSTRAINT faculty_educational_attainment_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id) ON DELETE CASCADE;


--
-- Name: faculty_email faculty_email_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_email
    ADD CONSTRAINT faculty_email_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id) ON DELETE CASCADE;


--
-- Name: faculty_extension faculty_extension_faculty_academic_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_extension
    ADD CONSTRAINT faculty_extension_faculty_academic_semester_id_fkey FOREIGN KEY (faculty_academic_semester_id) REFERENCES public.faculty_academic_semester(id) ON DELETE SET NULL;


--
-- Name: faculty_field_of_interest faculty_field_of_interest_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_field_of_interest
    ADD CONSTRAINT faculty_field_of_interest_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id) ON DELETE CASCADE;


--
-- Name: faculty_field_of_interest faculty_field_of_interest_field_of_interest_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_field_of_interest
    ADD CONSTRAINT faculty_field_of_interest_field_of_interest_id_fkey FOREIGN KEY (field_of_interest_id) REFERENCES public.field_of_interest(id) ON DELETE CASCADE;


--
-- Name: faculty_home_address faculty_home_address_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_home_address
    ADD CONSTRAINT faculty_home_address_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id) ON DELETE CASCADE;


--
-- Name: faculty faculty_latest_changelog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_latest_changelog_id_fkey FOREIGN KEY (latest_changelog_id) REFERENCES public.changelog(id) ON DELETE SET NULL;


--
-- Name: faculty_mentoring faculty_mentoring_faculty_academic_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_mentoring
    ADD CONSTRAINT faculty_mentoring_faculty_academic_semester_id_fkey FOREIGN KEY (faculty_academic_semester_id) REFERENCES public.faculty_academic_semester(id) ON DELETE SET NULL;


--
-- Name: faculty_mentoring faculty_mentoring_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_mentoring
    ADD CONSTRAINT faculty_mentoring_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE SET NULL;


--
-- Name: faculty_rank faculty_rank_appointment_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_rank
    ADD CONSTRAINT faculty_rank_appointment_status_fkey FOREIGN KEY (appointment_status) REFERENCES public.appointment_status(appointment_status) ON DELETE SET NULL;


--
-- Name: faculty_rank faculty_rank_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_rank
    ADD CONSTRAINT faculty_rank_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id) ON DELETE CASCADE;


--
-- Name: faculty_rank faculty_rank_rank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_rank
    ADD CONSTRAINT faculty_rank_rank_id_fkey FOREIGN KEY (rank_id) REFERENCES public.rank(id) ON DELETE SET NULL;


--
-- Name: faculty_research faculty_research_faculty_academic_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_research
    ADD CONSTRAINT faculty_research_faculty_academic_semester_id_fkey FOREIGN KEY (faculty_academic_semester_id) REFERENCES public.faculty_academic_semester(id) ON DELETE SET NULL;


--
-- Name: faculty_research faculty_research_research_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_research
    ADD CONSTRAINT faculty_research_research_id_fkey FOREIGN KEY (research_id) REFERENCES public.research(id) ON DELETE SET NULL;


--
-- Name: faculty faculty_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_status_fkey FOREIGN KEY (status) REFERENCES public.status(status) ON DELETE SET NULL;


--
-- Name: faculty_study_load faculty_study_load_faculty_academic_semester_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.faculty_study_load
    ADD CONSTRAINT faculty_study_load_faculty_academic_semester_id_fkey FOREIGN KEY (faculty_academic_semester_id) REFERENCES public.faculty_academic_semester(id) ON DELETE SET NULL;


--
-- Name: profile_info profile_info_latest_changelog_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.profile_info
    ADD CONSTRAINT profile_info_latest_changelog_id_fkey FOREIGN KEY (latest_changelog_id) REFERENCES public.changelog(id);


--
-- Name: profile_info profile_info_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.profile_info
    ADD CONSTRAINT profile_info_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profile(id) ON DELETE CASCADE;


--
-- Name: profile_info profile_info_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.profile_info
    ADD CONSTRAINT profile_info_role_fkey FOREIGN KEY (role) REFERENCES public.role(role);


--
-- Name: session session_user_id_profile_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: fims_dev
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_user_id_profile_id_fk FOREIGN KEY (user_id) REFERENCES public.profile(id) ON DELETE CASCADE;


--
-- Name: account_search_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: fims_dev
--

REFRESH MATERIALIZED VIEW public.account_search_view;


--
-- Name: faculty_record_search_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: fims_dev
--

REFRESH MATERIALIZED VIEW public.faculty_record_search_view;


--
-- PostgreSQL database dump complete
--

\unrestrict O8D1myO7RS2IzSJEitXVRzQgP67MfOCn4VsZPAnyFRNW7iZ1MZWseTTyDgjnqRI

