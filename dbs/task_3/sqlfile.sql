--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

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
-- Name: attributes; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attributes AS ENUM (
    'strength',
    'dexterity',
    'constitution',
    'intelligence'
);


ALTER TYPE public.attributes OWNER TO postgres;

--
-- Name: combat_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.combat_status AS ENUM (
    'on-going',
    'finished'
);


ALTER TYPE public.combat_status OWNER TO postgres;

--
-- Name: effect_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.effect_type AS ENUM (
    'stun',
    'damage',
    'heal'
);


ALTER TYPE public.effect_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action (
    id integer NOT NULL,
    action_type integer NOT NULL,
    target integer NOT NULL,
    character_id integer NOT NULL,
    combat_id integer,
    item_id integer,
    effect_value integer NOT NULL,
    hit boolean NOT NULL
);


ALTER TABLE public.action OWNER TO postgres;

--
-- Name: action_category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action_category (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    cost integer NOT NULL
);


ALTER TABLE public.action_category OWNER TO postgres;

--
-- Name: action_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.action_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.action_category_id_seq OWNER TO postgres;

--
-- Name: action_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.action_category_id_seq OWNED BY public.action_category.id;


--
-- Name: action_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.action_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.action_id_seq OWNER TO postgres;

--
-- Name: action_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.action_id_seq OWNED BY public.action.id;


--
-- Name: action_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.action_type (
    id integer NOT NULL,
    name character varying(256) NOT NULL,
    action_category integer NOT NULL,
    item_id integer,
    description character varying(8192),
    effect public.effect_type NOT NULL,
    cost integer NOT NULL,
    effect_value integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.action_type OWNER TO postgres;

--
-- Name: action_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.action_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.action_type_id_seq OWNER TO postgres;

--
-- Name: action_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.action_type_id_seq OWNED BY public.action_type.id;


--
-- Name: character; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."character" (
    id integer NOT NULL,
    name character varying(255),
    class_id integer NOT NULL,
    health integer NOT NULL,
    action_points integer NOT NULL,
    strength integer NOT NULL,
    dexterity integer NOT NULL,
    constitution integer NOT NULL,
    intelligence integer NOT NULL,
    in_combat boolean NOT NULL
);


ALTER TABLE public."character" OWNER TO postgres;

--
-- Name: character_actions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.character_actions (
    character_id integer NOT NULL,
    action_type_id integer NOT NULL
);


ALTER TABLE public.character_actions OWNER TO postgres;

--
-- Name: character_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.character_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.character_id_seq OWNER TO postgres;

--
-- Name: character_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.character_id_seq OWNED BY public."character".id;


--
-- Name: class; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class (
    id integer NOT NULL,
    name character varying(255),
    health integer NOT NULL,
    action_points integer NOT NULL,
    strength integer NOT NULL,
    dexterity integer NOT NULL,
    constitution integer NOT NULL,
    intelligence integer NOT NULL,
    armor_class integer NOT NULL,
    inventory_size integer NOT NULL
);


ALTER TABLE public.class OWNER TO postgres;

--
-- Name: class_attribute_modifier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.class_attribute_modifier (
    action_category_id integer NOT NULL,
    class_id integer NOT NULL,
    attribute public.attributes NOT NULL,
    value integer NOT NULL
);


ALTER TABLE public.class_attribute_modifier OWNER TO postgres;

--
-- Name: class_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.class_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.class_id_seq OWNER TO postgres;

--
-- Name: class_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.class_id_seq OWNED BY public.class.id;


--
-- Name: combat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.combat (
    id integer NOT NULL,
    combat_num integer NOT NULL,
    round integer NOT NULL,
    status public.combat_status NOT NULL
);


ALTER TABLE public.combat OWNER TO postgres;

--
-- Name: combat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.combat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.combat_id_seq OWNER TO postgres;

--
-- Name: combat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.combat_id_seq OWNED BY public.combat.id;


--
-- Name: inventory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inventory (
    character_id integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.inventory OWNER TO postgres;

--
-- Name: item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item (
    id integer NOT NULL,
    name character varying(255),
    description character varying(8192) NOT NULL,
    base_damage integer NOT NULL,
    weight integer NOT NULL
);


ALTER TABLE public.item OWNER TO postgres;

--
-- Name: item_attribute_modifier; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_attribute_modifier (
    item_id integer NOT NULL,
    class_id integer NOT NULL,
    attribute public.attributes NOT NULL,
    value integer NOT NULL
);


ALTER TABLE public.item_attribute_modifier OWNER TO postgres;

--
-- Name: item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.item_id_seq OWNER TO postgres;

--
-- Name: item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_id_seq OWNED BY public.item.id;


--
-- Name: playground; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.playground (
    combat_id integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.playground OWNER TO postgres;

--
-- Name: action id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action ALTER COLUMN id SET DEFAULT nextval('public.action_id_seq'::regclass);


--
-- Name: action_category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_category ALTER COLUMN id SET DEFAULT nextval('public.action_category_id_seq'::regclass);


--
-- Name: action_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_type ALTER COLUMN id SET DEFAULT nextval('public.action_type_id_seq'::regclass);


--
-- Name: character id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."character" ALTER COLUMN id SET DEFAULT nextval('public.character_id_seq'::regclass);


--
-- Name: class id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class ALTER COLUMN id SET DEFAULT nextval('public.class_id_seq'::regclass);


--
-- Name: combat id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combat ALTER COLUMN id SET DEFAULT nextval('public.combat_id_seq'::regclass);


--
-- Name: item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item ALTER COLUMN id SET DEFAULT nextval('public.item_id_seq'::regclass);


--
-- Name: action_category action_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_category
    ADD CONSTRAINT action_category_pkey PRIMARY KEY (id);


--
-- Name: action action_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_pkey PRIMARY KEY (id);


--
-- Name: action_type action_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_type
    ADD CONSTRAINT action_type_pkey PRIMARY KEY (id);


--
-- Name: character character_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT character_pkey PRIMARY KEY (id);


--
-- Name: class class_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class
    ADD CONSTRAINT class_pkey PRIMARY KEY (id);


--
-- Name: combat combat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.combat
    ADD CONSTRAINT combat_pkey PRIMARY KEY (id);


--
-- Name: item item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item
    ADD CONSTRAINT item_pkey PRIMARY KEY (id);


--
-- Name: action action_action_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_action_type_fkey FOREIGN KEY (action_type) REFERENCES public.action_type(id);


--
-- Name: action action_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_character_id_fkey FOREIGN KEY (character_id) REFERENCES public."character"(id);


--
-- Name: action action_combat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_combat_id_fkey FOREIGN KEY (combat_id) REFERENCES public.combat(id);


--
-- Name: action action_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: action action_target_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action
    ADD CONSTRAINT action_target_fkey FOREIGN KEY (target) REFERENCES public."character"(id);


--
-- Name: action_type action_type_action_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_type
    ADD CONSTRAINT action_type_action_category_fkey FOREIGN KEY (action_category) REFERENCES public.action_category(id);


--
-- Name: action_type action_type_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.action_type
    ADD CONSTRAINT action_type_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: character_actions character_actions_action_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.character_actions
    ADD CONSTRAINT character_actions_action_type_id_fkey FOREIGN KEY (action_type_id) REFERENCES public.action_type(id);


--
-- Name: character_actions character_actions_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.character_actions
    ADD CONSTRAINT character_actions_character_id_fkey FOREIGN KEY (character_id) REFERENCES public."character"(id);


--
-- Name: character character_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."character"
    ADD CONSTRAINT character_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.class(id);


--
-- Name: class_attribute_modifier class_attribute_modifier_action_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_attribute_modifier
    ADD CONSTRAINT class_attribute_modifier_action_category_id_fkey FOREIGN KEY (action_category_id) REFERENCES public.action_category(id);


--
-- Name: class_attribute_modifier class_attribute_modifier_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.class_attribute_modifier
    ADD CONSTRAINT class_attribute_modifier_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.class(id);


--
-- Name: inventory inventory_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_character_id_fkey FOREIGN KEY (character_id) REFERENCES public."character"(id);


--
-- Name: inventory inventory_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inventory
    ADD CONSTRAINT inventory_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: item_attribute_modifier item_attribute_modifier_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_attribute_modifier
    ADD CONSTRAINT item_attribute_modifier_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.class(id);


--
-- Name: item_attribute_modifier item_attribute_modifier_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_attribute_modifier
    ADD CONSTRAINT item_attribute_modifier_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- Name: playground playground_combat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playground
    ADD CONSTRAINT playground_combat_id_fkey FOREIGN KEY (combat_id) REFERENCES public.combat(id);


--
-- Name: playground playground_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playground
    ADD CONSTRAINT playground_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item(id);


--
-- PostgreSQL database dump complete
--

