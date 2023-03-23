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
    echo "Enter course id:"
    read course_id
    echo "Enter new teacher id:"
    read user_new_teacher_id

    return_exsist teacher $user_new_teacher_id
    reaturn_value_teacher=$?
    if [ $reaturn_value_teacher == 1 ]
    then
        echo "I am exsist"
    fi
}

function view_courses() {
    echo "==== View Courses ===="
    echo "Sl: ID      Name              Teacher"
    INPUT=course.csv
    INPUTTEACHER=teacher.csv
    count=0
    OLDIFS=$IFS
    IFS=','
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
    while read course_id course_name teacher_id
    do
        count=`expr $count + 1`
        while read file_teacher_id file_teacher_name
        do
            if [ "$file_teacher_id" == "$teacher_id" ]
            then
                echo "$count : $course_id, $course_name, $file_teacher_name"
            fi
        done < $INPUTTEACHER
    done < $INPUT
    IFS=$OLDIFS
}

# main program
choice="y"
while [ $choice == "y" ] || [ $choice == "Y" ]
do
    clear
    banner smt
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
                    clear
                    banner sms
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
                            echo "==== Create new semester ===="
                            create_semester
                            ;;
                        2)
                            cho "==== View semester ===="
                            cat -b semester.csv
                            ;;
                        3)
                            echo "==== Create new Course ===="
                            create_course
                            echo "Course Create Successfully"
                            ;;
                        4)
                            cho "==== View Courses ===="
                            view_courses
                            ;;
                        5)
                            clear
                            echo "==== Create new teacher ===="
                            create_objects teacher
                            ;;
                        6)
                            clear
                            cat -b teacher.csv
                            ;;
                        7)
                            clear
                            echo "==== Create new student ===="
                            create_objects student
                            ;;
                        8)
                            clear
                            view_single student
                            ;;
                        9)
                            modify_teacher
                            ;;
                        10)
                            echo "==== Add teacher into the course ===="
                            echo "Enter course id:"
                            read course_id
                            echo "Enter student id:"
                            read student_id
                            echo "Enter semester (Spring-2023):"
                            read user_semester

                            return_exsist semester $user_semester
                            semesterExsist=$?

                            return_exsist student $student_id
                            studentExsist=$?

                            return_exsist course $course_id
                            courseExsist=$?

                            if [ $semesterExsist == 1 ] && [ $studentExsist == 1 ] && [ $courseExsist == 1 ]
                            then
                                echo "yes you can enroll"
                            fi
                            ;;
                        *)
                            
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