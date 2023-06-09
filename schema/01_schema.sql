CREATE TYPE "conflict" AS ENUM (
  '1', -- Tags
  '2'  -- Discard
);

CREATE TABLE "instance" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY UNIQUE PRIMARY KEY,
  "category" TEXT NOT NULL,
  "data" JSON NOT NULL
);

CREATE TABLE "reviewer" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY UNIQUE PRIMARY KEY,
  "name" TEXT UNIQUE NOT NULL
);

CREATE TABLE "label" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY UNIQUE PRIMARY KEY,
  "name" TEXT UNIQUE NOT NULL,
  "added_at" TIMESTAMP DEFAULT (NOW())
);

CREATE TABLE "instance_review" (
  "id" INTEGER GENERATED BY DEFAULT AS IDENTITY UNIQUE PRIMARY KEY,
  "instance_id" INTEGER,
  "reviewer_id" INTEGER,
  "is_interesting" BOOLEAN NOT NULL DEFAULT false,
  "reviewed_at" TIMESTAMP DEFAULT (NOW()),
  "remarks" TEXT
);

CREATE TABLE "instance_discard" (
  "instance_id" INTEGER,
  "reviewer_id" INTEGER,
  "discarded_at" TIMESTAMP DEFAULT (NOW()),
  "remarks" text,
  PRIMARY KEY ("instance_id", "reviewer_id")
);

CREATE TABLE "instance_review_label" (
  "instance_review_id" INTEGER,
  "label_id" INTEGER,
  PRIMARY KEY ("instance_review_id", "label_id")
);

CREATE TABLE "instance_review_conflict_resolution" (
  "instance_id" INTEGER,
  "conflict" CONFLICT NOT NULL,
  "resolved_at" TIMESTAMP DEFAULT (NOW()),
  PRIMARY KEY ("instance_id", "conflict")
);

CREATE UNIQUE INDEX ON "instance_review" ("instance_id", "reviewer_id");

ALTER TABLE "instance_review" ADD FOREIGN KEY ("instance_id") REFERENCES "instance" ("id");
ALTER TABLE "instance_review" ADD FOREIGN KEY ("reviewer_id") REFERENCES "reviewer" ("id");
ALTER TABLE "instance_discard" ADD FOREIGN KEY ("instance_id") REFERENCES "instance" ("id");
ALTER TABLE "instance_discard" ADD FOREIGN KEY ("reviewer_id") REFERENCES "reviewer" ("id");
ALTER TABLE "instance_review_label" ADD FOREIGN KEY ("instance_review_id") REFERENCES "instance_review" ("id");
ALTER TABLE "instance_review_label" ADD FOREIGN KEY ("label_id") REFERENCES "label" ("id");
ALTER TABLE "instance_review_conflict_resolution" ADD FOREIGN KEY ("instance_id") REFERENCES "instance" ("id");
