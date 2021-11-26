# es2mssql

A demo of a basic pipeline that extracts data from Elasticsearch into Microsoft
SQL Server.

## Setting it all up

- Get docker and docker-compose (at least version 1.29.0)
- Run docker-compose up
    * NOTE: On first start up logstash will throw some errors due to the source
      and destination databases not being available at this point
- When it's all up navigate to http://localhost:5601 (kibana) and load
  the sample ecommerce dataset.
- Then connect to the SQL Server running at port 9999 and run the queries in
  `sqlserver/schema.sql`
- Restart the docker containers and wait for a minute or so, the data
  will start getting pushed to SQL Server

## How does it all work

A logstash configuration is defined in `logstash/es-loader.conf`. This
configuration specifies a pipeline that extracts data from Elasticsearch,
transforms it a bit and passes it over to SQL server.

The extraction is specified in the `input` section. `elasticsearch` is
set as the source and is configured to pull new orders from the
`kibana_sample_data_ecommerce` index that was created in
[Setting it all up](#setting-it-all-up) above. New orders are pulled every
10 minutes as specified by the schedule parameter. The schedule's value
uses a syntax similar to [crontab(5)](https://www.man7.org/linux/man-pages/man5/crontab.5.html).
A query that does the extraction from Elasticsearch is also defined. It
simply pulls all documents with an order date that's at least 10 minutes
before the current time.

Transformation is defined in the `filter` section. The transformation in
this setup is done on the customer_gender field only. It simply extracts
the first letter and converts it to uppercase. This is achieved by applying
the mutate filter plugin twice. First the text is converted to uppercase
and then the trailing ALE and EMALE are stripped out.

Loading is specified in the `output` section. Two outputs have been defined
in this configuration. The first being the jdbc output and the following,
just STDOUT. For the jdbc output, we specify the driver to be used in
communicating with SQL Server. A connection string and a query that binds
to the outputs of filter stage are also provided. If there is a need to
split the data into multiple tables then multiple jdbc outputs can be
specified, each with its own query.
    * NOTE: The jdbc output doesn't come builtin with logstash, it needs
      to be installed manually. Refer to `logstash/Dockerfile` for how to
      do this. You also need to get a database driver which you can get
      from Microsoft through a quick
      [web search](https://duckduckgo.com/?t=ffab&q=Microsoft+SQL+server+jdbc+driver&ia=web).


### References

- [Docker](https://docs.docker.com/engine/install/)
- [docker-compose](https://docs.docker.com/compose/install/)
- [Elasticsearch input plugin](https://www.elastic.co/guide/en/logstash/current/plugins-inputs-elasticsearch.html)
- [Logstash jdbc output plugin](https://github.com/theangryangel/logstash-output-jdbc)
- [The effin logstash manual](https://www.elastic.co/guide/en/logstash/current/introduction.html)
