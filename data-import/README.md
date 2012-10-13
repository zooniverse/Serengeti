Importing data
==============

Setup
-----

Make a MySQL database called "carnivore_coexistence".

Import "carnivorecoexistence_10-07-2012.sql" (from the science team).

Import "subjects_table.sql" (from this repo) to create an empty "zooniverse_subjects" table.

Generate manifest
-----------------

Point the manifest script at the directory containing the seasons. Then pass in the season, site and roll you want to import.

E.g. To generate records for a whole season: `./manifest path/to/seasons S1`

For a site: `./manifest path/to/seasons S1 B05`

For a roll: `./manifest path/to/seasons S1 B05 B05_R1`

Records will be created in the "zooniverse_subjects" table.

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
