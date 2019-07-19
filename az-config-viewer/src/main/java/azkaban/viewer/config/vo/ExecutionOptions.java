package azkaban.viewer.config.vo;

import azkaban.utils.JSONUtils;

import java.util.Map;

public class ExecutionOptions {
    private String lowerBound;
    private String upperBound;
    private String numPartitions;
    private String partitionColumn;

    public String getLowerBound() {
        return lowerBound;
    }

    public void setLowerBound(String lowerBound) {
        this.lowerBound = lowerBound;
    }

    public String getUpperBound() {
        return upperBound;
    }

    public void setUpperBound(String upperBound) {
        this.upperBound = upperBound;
    }

    public String getNumPartitions() {
        return numPartitions;
    }

    public void setNumPartitions(String numPartitions) {
        this.numPartitions = numPartitions;
    }

    public String getPartitionColumn() {
        return partitionColumn;
    }

    public void setPartitionColumn(String partitionColumn) {
        this.partitionColumn = partitionColumn;
    }

    public  String toJson(){
        if(this == null){
            return "";
        }
        String json = JSONUtils.toJSON(this, true);
        return json;
    }

    public static ExecutionOptions fromJson(String json){
        if(json== null || json.isEmpty()){
            return null;
        }
        ExecutionOptions  executionOptions = new ExecutionOptions();
        try{
            Map<String, Object> mapOptions = (Map<String, Object>)JSONUtils.parseJSONFromString(json);
            executionOptions.setLowerBound((String)mapOptions.get("lowerBound"));
            executionOptions.setUpperBound((String)mapOptions.get("upperBound"));
            executionOptions.setNumPartitions((String)mapOptions.get("numPartitions"));
            executionOptions.setPartitionColumn((String)mapOptions.get("partitionColumn"));
        }catch(Exception e){
            e.printStackTrace();
        }
        return executionOptions;
    }

    @Override
    public String toString() {
        return "ExecutionOptions{" +
                "lowerBound='" + lowerBound + '\'' +
                ", upperBound='" + upperBound + '\'' +
                ", numPartitions='" + numPartitions + '\'' +
                ", partitionColumn='" + partitionColumn + '\'' +
                '}';
    }
}
