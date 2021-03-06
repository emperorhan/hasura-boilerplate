CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.enum_history_type (
    type text NOT NULL,
    comment text NOT NULL
);
COMMENT ON TABLE public.enum_history_type IS '테이블 변경내역을 기록하는 히스토리 테이블에서 사용되는 생성, 편집, 삭제에 대한 타입';
CREATE TABLE public.enum_user_role (
    role text NOT NULL,
    comment text NOT NULL
);
CREATE TABLE public.task_history (
    id bigint NOT NULL,
    task_id integer NOT NULL,
    user_id integer NOT NULL,
    history_type text NOT NULL,
    column_name text NOT NULL,
    before text NOT NULL,
    after text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.task_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.task_history_id_seq OWNED BY public.task_history.id;
CREATE TABLE public.tasks (
    id integer NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);
CREATE SEQUENCE public.tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.tasks_id_seq OWNED BY public.tasks.id;
CREATE TABLE public.user_roles (
    user_id integer NOT NULL,
    role text NOT NULL
);
CREATE TABLE public.user_tasks (
    user_id integer NOT NULL,
    task_id integer NOT NULL,
    comment text
);
CREATE TABLE public.users (
    id integer NOT NULL,
    uuid uuid NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    account_name text NOT NULL,
    password text NOT NULL,
    salt text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone
);
CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
ALTER TABLE ONLY public.task_history ALTER COLUMN id SET DEFAULT nextval('public.task_history_id_seq'::regclass);
ALTER TABLE ONLY public.tasks ALTER COLUMN id SET DEFAULT nextval('public.tasks_id_seq'::regclass);
ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
ALTER TABLE ONLY public.enum_history_type
    ADD CONSTRAINT enum_history_type_pkey PRIMARY KEY (type);
ALTER TABLE ONLY public.enum_user_role
    ADD CONSTRAINT enum_user_role_pkey PRIMARY KEY (role);
ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role);
ALTER TABLE ONLY public.user_tasks
    ADD CONSTRAINT user_tasks_pkey PRIMARY KEY (user_id, task_id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_account_name_key UNIQUE (account_name);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_uuid_key UNIQUE (uuid);
CREATE TRIGGER set_public_tasks_updated_at BEFORE UPDATE ON public.tasks FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_tasks_updated_at ON public.tasks IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_users_updated_at ON public.users IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_history_type_fkey FOREIGN KEY (history_type) REFERENCES public.enum_history_type(type) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.task_history
    ADD CONSTRAINT task_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_fkey FOREIGN KEY (role) REFERENCES public.enum_user_role(role) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.user_tasks
    ADD CONSTRAINT user_tasks_task_id_fkey FOREIGN KEY (task_id) REFERENCES public.tasks(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.user_tasks
    ADD CONSTRAINT user_tasks_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;

-- ENUM data
INSERT INTO public.enum_history_type (type, comment) VALUES ('CREATION', '생성');
INSERT INTO public.enum_history_type (type, comment) VALUES ('EDITION', '편집');
INSERT INTO public.enum_history_type (type, comment) VALUES ('DELETION', '삭제');
INSERT INTO public.enum_user_role (role, comment) VALUES ('USER', '사용자 권한');
INSERT INTO public.enum_user_role (role, comment) VALUES ('ADMIN', '시스템 관리자 권한');
INSERT INTO public.enum_user_role (role, comment) VALUES ('ANONYMOUS', '비회원 권한');
-- SEQ data
SELECT pg_catalog.setval('public.task_history_id_seq', 1, false);
SELECT pg_catalog.setval('public.tasks_id_seq', 1, false);
SELECT pg_catalog.setval('public.users_id_seq', 1, false);
