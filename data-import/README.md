Importing data
==============

Setup
-----

Make a MySQL database called "carnivore_coexistence".

Import "carnivorecoexistence_10-07-2012.sql" (from the science team).

Import "subjects.sql" (from this repo) to create an empty "zooniverse_subjects" table.

Import
------

The images are divided into seasons, the script runs on one season at a time:

**TODO: Make this a site/roll/image at a time.**

```
./import path/to/S1
```

Now there are records in the "zooniverse_subjects" table.

Create Subjects
---------------

From an Ouroboros Rails console:

```
load 'path/to/Serengeti/data-import/to_ouroboros.rb'
```

Now there are subjects in Ouroboros.
Each record in "zooniverse_subjects" now has a "bson_id", "zooniverse_id", and "location".

Upload images to S3
-------------------

**TODO: For each `local_location` of each record in zooniverse_subjects, upload the file to the corresponding `location`.**
