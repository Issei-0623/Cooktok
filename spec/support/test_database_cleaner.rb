module TestDatabaseCleaner
  SKIPPED_TABLES = %w[
    ar_internal_metadata
    schema_migrations
  ].freeze

  def self.clean
    connection = ActiveRecord::Base.connection
    tables = connection.tables - SKIPPED_TABLES

    connection.disable_referential_integrity do
      tables.each do |table|
        connection.execute("TRUNCATE TABLE #{connection.quote_table_name(table)} RESTART IDENTITY CASCADE")
      end
    end
  end
end
