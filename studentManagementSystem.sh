#!/bin/bash

function create_semester() {
    echo "Enter the semester session(Spring/Fall):"
    read semester_session
    echo "Enter the semester year:"
    read semester_year
    semester="$semester_session-$semester_year"
    echo "$semester" >> semester.csv
}

function create_user() {
    echo "Enter $1 id:"
    read user_id
    echo "Enter $1 name:"
    read user_name
    if [ $1 == "teacher" ]
    then
        echo "$user_id,$user_name" >> teacher.csv 
    else 
        echo "$user_id,$user_name" >> student.csv 
    fi
}

function return_exsist() {
    INPUT=$1.csv
    OLDIFS=$IFS
    IFS=','

    if [ ! -f $INPUT ]
    then
        echo "$INPUT file not found"; exit;
    fi

    while read id name
    do
        if [ $2 == $id ]
        then
            return 1
        fi
    done < $INPUT
    IFS=$OLDIFS
}

function create_course() {
    echo "Enter course id:"
    read course_id
    echo "Enter course name:"
    read course_name
    echo "Enter teacher id:"
    read user_teacher_id
    echo "Enter sesmster(Spring-2023):"
    read semester

    return_exsist teacher $user_teacher_id
    reaturn_value_teacher=$?

    return_exsist semester $semester
    reaturn_value_semester=$?

    if [ $reaturn_value_teacher == 1 ]
    then
        if [ $reaturn_value_semester == 1 ]
        then
            echo "$course_id,$course_name,$semester,$user_teacher_id" >> course.csv
        else
            echo "Semester doesn't exsist"
        fi
    else
        echo "Teacher doesn't exsist"
    fi
}

function modify_teacher() {
    echo "==== Modify Courses Teacher ===="
    echo "Enter course id:"
    read user_course_id
    echo "Enter semester(Spring-2023):"
    read user_semester
    echo "Enter new teacher id:"
    read user_new_teacher_id

    return_exsist teacher $user_new_teacher_id
    reaturn_value_teacher=$?

    if [ $reaturn_value_teacher == 1 ]
    then
        INPUT=course.csv
        count=0
        OLDIFS=$IFS
        IFS=','
        [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
        while read course_id course_name semester teacher_id
        do
            if [ "$course_id" == "$user_course_id" ] && [ "$user_semester" == $semester ]
            then
                echo "$course_id,$course_name,$semester,$user_new_teacher_id" >> temp_course.csv
            else
                echo "$course_id,$course_name,$semester,$teacher_id" >> temp_course.csv
            fi
        done < $INPUT
        IFS=$OLDIFS
        echo "Teacher susccessfully modifyed"
    else
        echo "Teacher dosen't exsist"
    fi

    # Remove the previous file and rename the exsisting file.
    rm course.csv
    mv temp_course.csv course.csv
}

function view_courses() {
    echo "==== View Courses ===="
    echo "Sl: ID      Name                 Semester      Teacher"
    INPUT=course.csv
    INPUTTEACHER=teacher.csv
    count=0
    OLDIFS=$IFS
    IFS=','
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
    [ ! -f $INPUTTEACHER ] && { echo "$INPUTTEACHER file not found"; exit; }
    while read course_id course_name semester teacher_id
    do
        count=`expr $count + 1`
        while read file_teacher_id file_teacher_name
        do
            if [ "$file_teacher_id" == "$teacher_id" ]
            then
                echo "$count : $course_id  $course_name     $semester   $file_teacher_name"
            fi
        done < $INPUTTEACHER
    done < $INPUT
    IFS=$OLDIFS
}

function enroll_course() {
    echo "Enter course id:"
    read user_course_id
    echo "Enter student id:"
    read user_student_id
    echo "Enter semester (Spring-2023):"
    read user_semester

    return_exsist semester $user_semester
    semesterExsist=$?

    return_exsist student $user_student_id
    studentExsist=$?

    return_exsist course $user_course_id
    courseExsist=$?

    if [ $semesterExsist != 1 ]; then
        echo "Semester doesn't exsist"
    else
        if [ $studentExsist != 1 ]; then
            echo "Student doesn't exsist"
        else
            if [ $courseExsist != 1 ]; then
                echo "Course doesn't exsist"
            else
                echo "$user_course_id,$user_student_id,$user_semester,0,0,0,0" >> courseEnroll.csv
                echo "Student Successfully Enroll into the course" 
            fi
        fi
    fi
}

function head_banner() {
    clear
    banner SMS
}

# main program
choice="y"
while [ $choice == "y" ] || [ $choice == "Y" ]
do
    head_banner
    echo "Enter the user type"
    echo "1. Admin"
    echo "2. Teacher"
    echo "3. Student"
    echo "4. Exit"
    echo "Enter your choice: "
    read user_type

    case "$user_type" in
        1)
            echo "Enter admin password: "
            read admin_password
            if [ "$admin_password" = "admin123" ]; then

                # Repeating the admin choice
                choice="y"
                while [ $choice == "y" ] || [ $choice == "Y" ]
                do
                    head_banner
                    echo "==== Admin menu ===="
                    echo "1. Create Semester"
                    echo "2. View Semesters"
                    echo "3. Create Course"
                    echo "4. View Courses"
                    echo "5. Create Teacher"
                    echo "6. View Teachers"
                    echo "7. Create Student"
                    echo "8. View Students"
                    echo "9. Modify course teacher"
                    echo "10. Enroll students into the course"
                    echo "11. Exit"
                    echo "Please enter your choice:"
                    
                    read choice

                    case "$choice" in
                        1)
                            head_banner
                            echo "==== Create new semester ===="
                            create_semester
                            ;;
                        2)
                            head_banner
                            echo "==== View semester ===="
                            cat -b semester.csv
                            ;;
                        3)
                            head_banner
                            echo "==== Create new Course ===="
                            create_course
                            echo "Course Create Successfully"
                            ;;
                        4)
                            head_banner
                            view_courses
                            ;;
                        5)
                            head_banner
                            echo "==== Create new teacher ===="
                            create_objects teacher
                            ;;
                        6)
                            head_banner
                            echo "==== View teacher ===="
                            cat -b teacher.csv
                            ;;
                        7)
                            head_banner
                            echo "==== Create new student ===="
                            create_objects student
                            ;;
                        8)
                            head_banner
                            echo "==== View students ===="
                            cat -b student.csv
                            ;;
                        9)
                            head_banner
                            echo "==== Modify Course Teacher ===="
                            modify_teacher
                            ;;
                        10)
                            head_banner
                            echo "==== Enroll into the course ===="
                            enroll_course
                            ;;
                        11)
                            exit
                            ;;
                        *)
                            echo "Invalid input"
                            ;;
                    esac
                    # Ask user if they want to continue
                    echo "Do you want to continue [y/n]: "
                    read choice
                done
                echo "exit form admin"
            else
                echo "Invalid credentials"
            fi
            ;;
        *)
            echo "Invalid Input"
            ;;
    esac
    # Ask user if they want to continue
    echo "Do you want to continue [y/n]: "
    read choice
done