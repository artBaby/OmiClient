package netCrackerApp.objects;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;


public class JsonHistory {
    private String createdDate;
    private String topic;

    @JsonCreator
    public JsonHistory(@JsonProperty("createdDate") String createdDate, @JsonProperty("topic") String topic) {
        this.createdDate = createdDate;
        this.topic = topic;
    }


    public String getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(String createdDate) {
        this.createdDate = createdDate;
    }

    public String getTopic() {
        return topic;
    }

    public void setTopic(String topic) {
        this.topic = topic;
    }
}
