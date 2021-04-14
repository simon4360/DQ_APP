package com.microgen.quality.ut;

public class AptitudeProjectWorkflow {
    private String projectName = "";
    private String workflowName = "";
    
    public AptitudeProjectWorkflow (String pProjectName, String pWorkflowName) {
        this.projectName = pProjectName;
        this.workflowName = pWorkflowName;
    }
    
    public String getProjectName() {
        return projectName;
    }
    
    public String getWorkflowName() {
        return workflowName;
    }
    
    public String toString(){
        return "Workflow: " + this.workflowName + ", Project: " + this.projectName;
    }

}
