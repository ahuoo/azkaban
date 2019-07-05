package azkaban.viewer.config.vo;
import azkaban.executor.Status;

import java.util.Date;

public class JobStatus {
    private Integer id;
    private String lob;
    private String source;
    private String target;
    private Status status;
    private String errorMsg;
    private Long beginDt;
    private Long endDt;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getLob() {
        return lob;
    }

    public void setLob(String lob) {
        this.lob = lob;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getTarget() {
        return target;
    }

    public void setTarget(String target) {
        this.target = target;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public String getErrorMsg() {
        return errorMsg;
    }

    public void setErrorMsg(String errorMsg) {
        this.errorMsg = errorMsg;
    }

    public Long getBeginDt() {
        return beginDt;
    }

    public void setBeginDt(Long beginDt) {
        this.beginDt = beginDt;
    }

    public Long getEndDt() {
        return endDt;
    }

    public void setEndDt(Long endDt) {
        this.endDt = endDt;
    }
}
