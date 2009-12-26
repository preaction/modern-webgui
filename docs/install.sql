
ALTER TABLE asset ADD COLUMN rank INT;
CREATE TABLE RawContent (
   assetId CHAR(22) BINARY NOT NULL, 
   revisionDate BIGINT, 
   content LONGTEXT, 
   contentPacked LONGTEXT, 
   mimeType CHAR(100), 
   cacheTimeout BIGINT, 
   usePacked BIT, 
   PRIMARY KEY (assetId, revisionDate) 
);
