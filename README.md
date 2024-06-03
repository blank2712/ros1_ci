# STEPS TO TEST TORTOISEBOT AND WAYPOINTS

### Access Jenkins
```console
cd 
source run_jenkins.sh
cat jenkins__pid__url.txt
```
### Access the Jenkins URL and log in with the following credentials:
```
Username: user
Password: s@mmd7ca91
```
### Build Jenkins
```
Enter the following job: tortoisebot_cli
Build the job
```

# How to push changes a into the repository

Now, you can change something in the code. For example:

```console
cd ~/catkin_ws/src/ros1_ci
echo "jenkins" > file_to_test.txt
```

Execute these steps in the command line interface:

```console
git add .
git commit -m "Created file to test"
git push origin master
```
