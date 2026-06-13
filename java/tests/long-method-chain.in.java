               HeadObjectResponse response = getClient(transactionId, configuration).headObject(HeadObjectRequest.builder()
                       .bucket(location.bucket)
                       .key(location.key)
                       .build())
.doIt();
