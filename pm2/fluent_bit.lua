function set_index(tag, timestamp, record)
    record["es_index"] = "log"
                    .. record["region"]
                    .. record["service"]
    return 1, timestamp, record
end