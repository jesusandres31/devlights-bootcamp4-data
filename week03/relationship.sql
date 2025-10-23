--
-- One-to-One (1–1)
--

CREATE TABLE "person" (
  "id" integer PRIMARY KEY,
  "name" varchar
);

CREATE TABLE "passport" (
  "id" integer PRIMARY KEY,
  "passport_number" varchar,
  "person_id" integer UNIQUE
);

ALTER TABLE "passport" ADD FOREIGN KEY ("person_id") REFERENCES "person" ("id");

--
-- One-to-Many (1–N)
--

CREATE TABLE "users" (
  "id" integer PRIMARY KEY,
  "username" varchar
);

CREATE TABLE "posts" (
  "id" integer PRIMARY KEY,
  "title" varchar,
  "user_id" integer NOT NULL
);

ALTER TABLE "posts" ADD FOREIGN KEY ("user_id") REFERENCES "users" ("id");

--
-- One-to-Many (1–N)
--

CREATE TABLE "students" (
  "id" integer PRIMARY KEY,
  "name" varchar,
  "email" varchar,
  "created_at" timestamp
);

CREATE TABLE "courses" (
  "id" integer PRIMARY KEY,
  "title" varchar,
  "description" text,
  "created_at" timestamp
);

CREATE TABLE "student_courses" (
  "student_id" integer NOT NULL,
  "course_id" integer NOT NULL,
  "enrollment_date" timestamp
);

CREATE UNIQUE INDEX ON "student_courses" ("student_id", "course_id"); 

ALTER TABLE "student_courses" ADD FOREIGN KEY ("student_id") REFERENCES "students" ("id");

ALTER TABLE "student_courses" ADD FOREIGN KEY ("course_id") REFERENCES "courses" ("id");
