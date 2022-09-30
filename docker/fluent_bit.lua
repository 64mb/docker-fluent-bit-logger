function set_index(tag, timestamp, record)
    if record["region"] == nil or record["region"] == "-" then
        record["es_index"] = "log"
                    .. "-"
                    .. record["service"]
    else
        record["es_index"] = "log"
                        .. "-"
                        .. record["region"]
                        .. "-"
                        .. record["service"]
    end
    return 1, timestamp, record
end

function set_service(tag, timestamp, record)
    if not(record["container_name"] == nil or record["container_name"] == '') then
        if record["container_name"]:sub(-string.len("_green")) == "_green" then
            record["service"] = record["container_name"]:sub(2,-string.len("_green")-1)
        elseif record["container_name"]:sub(-string.len("_blue")) == "_blue" then
            record["service"] = record["container_name"]:sub(2,-string.len("_blue")-1)
        else
            record["service"] = record["container_name"]:sub(2)
        end
    else
        record["service"] = "error"
    end
    return 1, timestamp, record
end