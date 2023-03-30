#!/bin/bash

# Author Name: Francis Rudra D Cruze
# Author Email: francisrudra@gmail.com
# Social Media: https://www.linkedin.com/in/rudradcruze/
# © All rights reserved by rudradcruze - 2023

function head_banner() {
    clear
    banner SMS
    echo "Developed by (linkedin.com/in/rudradcruze) or '@rudradcruze' [All rights reserved]"
}

function return_function_value() {
    INPUT=$1.csv
    OLDIFS=$IFS
    function_return_value=0
    IFS=','
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
    while read id name ex ex1
    do
        if [ $2 == $id ]
        then
            if [ $3 == 1 ]
            then
                function_return_value="$id"
            elif [ $3 == 2 ]
            then
                function_return_value="$name"
            elif [ $3 == 3 ]
            then
                function_return_value="$ex"
            else [ $4 == 4 ]
                function_return_value="$ex1"
            fi
            break
        fi
    done < $INPUT
    IFS=$OLDIFS
}

function create_semester() {
    echo "Enter the semester session(Spring/Fall):"
    read semester_session
    echo "Enter the semester year:"
    read semester_year
    semester="$semester_session-$semester_year"

    return_function_value semester $semester 1
    local create_semester_value_exsist=$function_return_value

    if [ "$create_semester_value_exsist" != "$semester" ]
    then
        echo "$semester" >> semester.csv
        echo "$semester Semester Create successfully, Semester's are:"

        cat -b semester.csv
    else
        echo "Semester Already Exsist"
    fi
}

function create_user() {
    echo "Enter $1 id:"
    read user_id
    echo "Enter $1 name:"
    read user_name

    return_function_value $1 $user_id 1
    local get_return_user_id=$function_return_value

    if [ $get_return_user_id != $user_id ]
    then
        if [ $1 == "teacher" ]
        then
            echo "$user_id,$user_name" >> teacher.csv
        else 
            echo "$user_id,$user_name" >> student.csv 
        fi

        echo "$user_id $1 create successfully"
    else
        echo "$user_id is already exsist in $1 table"
    fi
}

function create_course() {
    echo "Enter course id:"
    read course_id
    echo "Enter course name:"
    read course_name
    echo "Enter teacher id:"
    read user_teacher_id
    echo "Enter sesmster(Spring-2023):"
    read create_course_semester

    return_function_value teacher $user_teacher_id 2
    reaturn_value_teacher=$function_return_value

    return_function_value semester $create_course_semester 1
    reaturn_value_semester=$function_return_value

    if [ $reaturn_value_teacher != 0 ]
    then
        if [ $reaturn_value_semester != 0 ]
        then
            echo "$course_id,$course_name,$create_course_semester,$user_teacher_id" >> course.csv
            echo "Course Create Successfully"
            view_courses
        else
            echo "Semester doesn't exsist"
            exit
        fi
    else
        echo "Teacher doesn't exsist"
        exit
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

    return_function_value teacher $user_new_teacher_id 2
    reaturn_value_teacher=$function_return_value

    if [ $reaturn_value_teacher != 0 ]
    then
        INPUT=course.csv
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
        
        # Remove the previous file and rename the exsisting file.
        rm course.csv
        mv temp_course.csv course.csv

        view_courses
    else
        echo "Teacher dosen't exsist"
    fi
}

function delete_student() {
    cat -b student.csv

    echo "Enter student id:"
    read user_delete_student_id

    return_function_value student $user_delete_student_id 2
    reaturn_value_delete_student=$function_return_value

    if [ $reaturn_value_delete_student != 0 ]
    then
        INPUT=student.csv
        count=0
        OLDIFS=$IFS
        IFS=','
        [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
        while read delete_file_s_id delete_file_s_name
        do
            if [ $user_delete_student_id != $delete_file_s_id ]
            then
                echo "$delete_file_s_id,$delete_file_s_name" >> tempDeleteStudent.csv
            fi
        done < $INPUT
        IFS=$OLDIFS
        
        echo "Student Successfully Delete"

        # Remove the previous file and rename the exsisting file.
        rm student.csv
        mv tempDeleteStudent.csv student.csv
    else
        echo "Student not exsist"
        exit
    fi
}

function return_course_count() {
    INPUT=courseEnroll.csv
    OLDIFS=$IFS
    local return_course_cunt_value=0
    IFS=','
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
    while read course_id student_id semester attendance quiz mid final
    do
        if [ $course_id == $1 ]
        then
            return_course_cunt_value=`expr $return_course_cunt_value + 1`
        fi
    done < $INPUT
    IFS=$OLDIFS
    return $return_course_cunt_value
}

function view_courses() {
    echo -e "=============================================  View Courses =============================================\n"
    echo -e "Sl: ID\t\tName\t\t\tSemester\tTeacher Id\tTeacher\tName\tEnrolled Students\n"
    INPUT=course.csv
    INPUTCOURSEENROLL=courseEnroll.csv
    local counting=0
    OLDIFS=$IFS
    IFS=','
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
    while read course_id course_name semester teacher_id
    do
        local temp_course_id=$course_id
        local temp_semester=$semester

        counting=`expr $counting + 1`
        return_function_value teacher $teacher_id 2
        file_teacher_name=$function_return_value

        return_course_count $course_id
        local course_count=$?
        
        echo -e "$counting : $temp_course_id\t$course_name\t$temp_semester\t$teacher_id\t\t$file_teacher_name\t\t$course_count"
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

    return_function_value semester $user_semester 1
    local semesterExsist=$function_return_value

    return_function_value student $user_student_id 2
    local studentExsist=$function_return_value

    return_function_value course $user_course_id 2
    local courseExsist=$function_return_value

    if [ $semesterExsist == 0 ] || [ $studentExsist == 0 ] || [ $courseExsist == 0 ]
    then
        echo "Semester, Student, Cources may not exsist."
        exit
    else
        echo "$user_course_id,$user_student_id,$user_semester,0,0,0,0" >> courseEnroll.csv
        echo "Student Successfully Enroll into the course"
    fi
}

function view_course_enrollments() {
    echo "====================== View Student Course Enrollment ======================"
    echo -e "Sl: SID      SName                       Semester         Course Name\n"
    INPUT=courseEnroll.csv
    counting_course_enroll_view=0
    OLDIFS=$IFS
    IFS=','
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
    while read course_id student_id semester attendance quiz midterm final
    do
        counting_course_enroll_view=`expr $counting_course_enroll_view + 1`
        return_function_value course $course_id 2
        course_enrollment_course_name=$function_return_value
        return_function_value student $student_id 2
        course_enrollment_student_name=$function_return_value

        echo "$counting_course_enroll_view : $student_id     $course_enrollment_student_name                   $semester           $course_enrollment_course_name" 

    done < $INPUT
    IFS=$OLDIFS
}

function teacher_course_enrolled_students() {
    echo -e "Sl: SID\t\tName\t\tSemester\t  CID\t\tCourse Name\t\t(Attendance,quiz,Mid,Final)"
    INPUT=courseEnroll.csv
    INPUTCOURSE=course.csv
    local counting_course_enrolld_student_view=0
    OLDIFS=$IFS
    IFS=','

    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
    [ ! -f $INPUTCOURSE ] && { echo "$INPUTCOURSE file not found"; exit; }

    while read course_id student_id semester attendance quiz midterm final
    do
        counting_course_enrolld_student_view=`expr $counting_course_enrolld_student_view + 1`

        while read course_course_id course_course_name course_semester course_teacher_id
        do
            if [ $course_id == $course_course_id ] && [ $semester == $course_semester ] && [ $1 == $course_teacher_id ]
            then
                return_function_value student $student_id 2
                teacher_course_enrolled_student_name=$function_return_value

                echo -e "$counting_course_enrolld_student_view : $student_id\t$teacher_course_enrolled_student_name\t$semester\t  $course_course_id\t$course_course_name\t$attendance,$quiz,$midterm,$final" 
            fi
        done < $INPUTCOURSE
    done < $INPUT
    IFS=$OLDIFS
}

function teacher_course_students_marks() {
    echo "Enter student id:"
    read teacher_update_student_id
    echo "Enter course id:"
    read teacher_update_course_id
    echo "Enter semester(Spring-2023):"
    read teacher_update_semester

    INPUT=courseEnroll.csv
    INPUTCOURSE=course.csv
    OLDIFS=$IFS
    IFS=','

    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
    [ ! -f $INPUTCOURSE ] && { echo "$INPUTCOURSE file not found"; exit; }

    echo "Enter attendacne marks(Max 15):"
    read update_student_attendance_marks
    echo "Enter quiz marks(max 15):"
    read update_student_quiz_marks
    echo "Enter midterm marks(max 30):"
    read update_student_mid_marks
    echo "Enter final marks(max 40):"
    read update_student_final_marks

    if [ $update_student_attendance_marks -gt 15 ] || [ $update_student_quiz_marks -gt 15 ] || [ $update_student_mid_marks -gt 30 ] || [ $update_student_final_marks -gt 40 ]
    then
        echo -e "\aPlease check the maximum number barrier"
        exit
    fi

    while read course_id student_id semester attendance quiz midterm final
    do
        flag="false"
        while read course_course_id course_course_name course_semester course_teacher_id
        do
            if [ $course_id == $teacher_update_course_id ] && [ $teacher_update_student_id == $student_id ] && [ $teacher_update_semester == $semester ] && [ $course_id == $course_course_id ] && [ $semester == $course_semester ] && [ $1 == $course_teacher_id ]
            then
                echo -e "\aStudent accssed"
                # Take marks input from users
                echo "$teacher_update_course_id,$teacher_update_student_id,$teacher_update_semester,$update_student_attendance_marks,$update_student_quiz_marks,$update_student_mid_marks,$update_student_final_marks" >> tempCourseEnroll.csv
                echo "Marks update successfully"
                flag="done"
            fi
        done < $INPUTCOURSE
        if [ $flag != "done" ]
        then
            echo "$course_id,$student_id,$semester,$attendance,$quiz,$midterm,$final" >> tempCourseEnroll.csv
        fi
    done < $INPUT
    IFS=$OLDIFS

    # Remove the previous file and rename the exsisting file.
    rm courseEnroll.csv
    mv tempCourseEnroll.csv courseEnroll.csv
}

function view_students_info_admin() {
    echo -e "======================================================= View Students =======================================================\n"
    echo -e "Sl: ID\t\tName\t\t\tCourse Code\tCourse Name\t\tTeacher\t\t(Attendance,quiz,Mid,Final)\n"
    INPUT=student.csv
    INPUTCOURSEENROLLMENT=courseEnroll.csv
    INPUTCOURSE=course.csv
    local counting=0
    OLDIFS=$IFS
    IFS=','
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit; }
    [ ! -f $INPUTCOURSEENROLLMENT ] && { echo "$INPUTCOURSEENROLLMENT file not found"; exit; }
    [ ! -f $INPUTCOURSE ] && { echo "$INPUTCOURSE file not found"; exit; }
    while read student_student_id student_student_name
    do
        counting=`expr $counting + 1`

        echo -e "$counting : $student_student_id\t$student_student_name"

        while read en_course_id en_student_id en_semester en_attendance en_quiz en_mid en_final
        do
            while read course_course_id course_course_name course_semester course_teacher_id
            do
                if [ $student_student_id == $en_student_id ] && [ $en_course_id == $course_course_id ] && [ $en_semester == $course_semester ]
                then
                    return_function_value teacher $course_teacher_id 2
                    local file_teacher_name=$function_return_value

                    echo -e "\t\t\t$en_semester\t$course_course_id\t\t$course_course_name\t$file_teacher_name\t\t$en_attendance,$en_quiz,$en_mid,$en_final"
                fi
            done < $INPUTCOURSE
        done < $INPUTCOURSEENROLLMENT
        echo ""      
    done < $INPUT
    IFS=$OLDIFS
}

function view_students_search() {
    echo -e "======================================================= Search Students =======================================================\n"
    echo "Enter student id:"
    read user_search_student_id

    echo -e "Sl: ID\t\tName\t\t\tCourse Code\tCourse Name\t\tTeacher\t\t(Attendance,quiz,Mid,Final)\n"
    INPUTCOURSEENROLLMENT=courseEnroll.csv
    INPUTCOURSE=course.csv
    local counting=0
    OLDIFS=$IFS
    IFS=','
    [ ! -f $INPUTCOURSEENROLLMENT ] && { echo "$INPUTCOURSEENROLLMENT file not found"; exit; }
    [ ! -f $INPUTCOURSE ] && { echo "$INPUTCOURSE file not found"; exit; }

        counting=`expr $counting + 1`

        return_function_value student $user_search_student_id 2
        local file_student_name=$function_return_value

        if [ $file_student_name == 0 ]
        then
            echo "$user_search_student_id doesn't exsist" 
            exit
        fi

        echo -e "$counting : $user_search_student_id\t$file_student_name"

        while read en_course_id en_student_id en_semester en_attendance en_quiz en_mid en_final
        do
            while read course_course_id course_course_name course_semester course_teacher_id
            do
                if [ $user_search_student_id == $en_student_id ] && [ $en_course_id == $course_course_id ] && [ $en_semester == $course_semester ]
                then
                    return_function_value teacher $course_teacher_id 2
                    local file_teacher_name=$function_return_value

                    echo -e "\t\t\t$en_semester\t$course_course_id\t\t$course_course_name\t$file_teacher_name\t\t$en_attendance,$en_quiz,$en_mid,$en_final"
                fi
            done < $INPUTCOURSE
        done < $INPUTCOURSEENROLLMENT
    IFS=$OLDIFS
}

function greade_return() {
    sum=`expr $1 + $2 + $3 + $4`
    
    if [ $sum -ge 80 ]; then
    	greade_show="A+"
    elif [ $sum -ge 75 ]; then
    	greade_show="A"
    elif [ $sum -ge 70 ]; then
    	greade_show="A-"
    elif [ $sum -ge 65 ]; then
    	greade_show="B+"
    elif [ $sum -ge 60 ]; then
    	greade_show="B"
    elif [ $sum -ge 55 ]; then
    	greade_show="B-"
    elif [ $sum -ge 50 ]; then
    	greade_show="C+"
    elif [ $sum -ge 45 ]; then
    	greade_show="C"
    elif [ $sum -ge 40 ]; then
    	greade_show="D"
    else
    	greade_show="F"
    fi
}

function view_single_student() {
    echo -e "============================================================ Students =============================================================\n"
    echo -e "Sl: ID\t\tName\t\t\tCourse Code\tCourse Name\t\tTeacher\t\t(Attendance,quiz,Mid,Final) = Grade\n"
    INPUTCOURSEENROLLMENT=courseEnroll.csv
    INPUTCOURSE=course.csv
    local counting=0
    OLDIFS=$IFS
    IFS=','
    [ ! -f $INPUTCOURSEENROLLMENT ] && { echo "$INPUTCOURSEENROLLMENT file not found"; exit; }
    [ ! -f $INPUTCOURSE ] && { echo "$INPUTCOURSE file not found"; exit; }

        counting=`expr $counting + 1`

        return_function_value student $1 2
        local file_student_name=$function_return_value

        if [ $file_student_name == 0 ]
        then
            echo "$1 doesn't exsist" 
            exit
        fi

        echo -e "$counting : $1\t$file_student_name"

        while read en_course_id en_student_id en_semester en_attendance en_quiz en_mid en_final
        do
            while read course_course_id course_course_name course_semester course_teacher_id
            do
                if [ $1 == $en_student_id ] && [ $en_course_id == $course_course_id ] && [ $en_semester == $course_semester ]
                then
                    return_function_value teacher $course_teacher_id 2
                    local file_teacher_name=$function_return_value

                    greade_return $en_attendance $en_quiz $en_mid $en_final
                    local grade=$greade_show

                    echo -e "\t\t\t$en_semester\t$course_course_id\t\t$course_course_name\t$file_teacher_name\t\t$en_attendance,$en_quiz,$en_mid,$en_final = $grade"
                fi
            done < $INPUTCOURSE
        done < $INPUTCOURSEENROLLMENT
    IFS=$OLDIFS
    echo -e "\n===================================================================================================================================\n"
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
                    echo "=============== Admin menu ==============="
                    echo -e "=\t\t\t\t\t ="
                    echo "===============  User Work ==============="
                    echo -e "=\t\t\t\t\t ="
                    echo -e "= 1.  Create Teacher\t\t\t ="
                    echo -e "= 2.  View Teachers\t\t\t ="
                    echo -e "= 3.  Create Student\t\t\t ="
                    echo -e "= 4.  View Students\t\t\t ="
                    echo -e "= 5.  Search Students Info\t\t ="
                    echo -e "=\t\t\t\t\t ="
                    echo "=============== Course Work =============="
                    echo -e "=\t\t\t\t\t ="
                    echo -e "= 6.  Create Semester\t\t\t ="
                    echo -e "= 7.  View Semesters\t\t\t ="
                    echo -e "= 8.  Create Course\t\t\t ="
                    echo -e "= 9.  View Courses\t\t\t ="
                    echo -e "= 10. Modify course teacher\t\t ="
                    echo -e "= 11. Enroll students into the course\t ="
                    echo -e "= 12. View Students Course Enrollments\t ="
                    echo -e "= 13. Delete Student\t\t\t ="
                    echo -e "= 14. Exit\t\t\t\t ="
                    echo "=========================================="
                    echo "Please enter your choice:"
                    
                    read choice

                    case "$choice" in
                        1)
                            head_banner
                            echo "==== Create new teacher ===="
                            create_user teacher
                            ;;
                        2)
                            head_banner
                            echo "==== View teacher ===="
                            cat -b teacher.csv
                            ;;
                        3)
                            head_banner
                            echo "==== Create new student ===="
                            create_user student
                            ;;
                        4)
                            head_banner
                            view_students_info_admin
                            ;;
                        5)
                            head_banner
                            view_students_search
                            ;;
                        6)
                            head_banner
                            echo "==== Create new semester ===="
                            create_semester
                            ;;
                        7)
                            head_banner
                            echo "==== View semester ===="
                            cat -b semester.csv
                            ;;
                        8)
                            head_banner
                            echo "==== Create new Course ===="
                            create_course
                            ;;
                        9)
                            head_banner
                            view_courses
                            ;;
                        10)
                            head_banner
                            echo "==== Modify Course Teacher ===="
                            modify_teacher
                            ;;
                        11)
                            head_banner
                            view_courses
                            echo -e "\n=============== Enroll into the course ===============\n"
                            enroll_course
                            ;;
                        12)
                            head_banner
                            view_course_enrollments               
                            ;;
                        13)
                            head_banner
                            echo "==== Delete Student ===="
                            delete_student
                            ;;
                        14)
                            exit
                            ;;
                        *)
                            echo "Invalid input"
                            ;;
                    esac
                    # Ask user if they want to continue
                    echo -e "\nDo you want to continue [y/n]: "
                    read choice
                done
                echo "exit form admin"
            else
                echo "Invalid credentials"
            fi
            ;;
        2)
            echo "Enter teacher id: "
            read teacher_id_for_teacher
            
            return_function_value teacher $teacher_id_for_teacher 2
            teacher_teacher_exsist_entry=$function_return_value

            if [ "$teacher_teacher_exsist_entry" == 0 ]
            then
                echo "Teacher not exsist"
            else
                # repeating teacher choice
                choice="y"
                while [ $choice == "y" ] || [ $choice == "Y" ]
                do
                    head_banner

                    echo -e "\n=========================================="
                    echo -e "= \t   Welcome $teacher_teacher_exsist_entry\t         ="
                    echo "============== Teacher menu =============="
                    echo -e "=\t\t\t\t\t ="
                    echo -e "= 1.  View Enroll Stdents\t\t ="
                    echo -e "= 2.  Update Student Marks\t\t ="
                    echo -e "= 3.  Exit\t\t\t\t ="
                    echo "=========================================="
                    echo "Please enter your choice:"

                    read choice

                    case "$choice" in
                        1)
                            head_banner
                            echo "==== View teacher course enrolled students ===="
                            teacher_course_enrolled_students $teacher_id_for_teacher
                            ;;
                        2)
                            head_banner
                            echo "==== Update or insert student marks ===="
                            teacher_course_enrolled_students $teacher_id_for_teacher
                            echo -e "\n\n"
                            teacher_course_students_marks $teacher_id_for_teacher
                            ;;
                        3)
                            exit
                            ;;
                        *)
                            echo "Invalid input"
                            ;;
                    esac
                    # Ask user if they want to continue
                    echo -e "\nDo you want to perfrom another operaion [y/n]: "
                    read choice
                done
                echo "Exsit form teacher"
            fi
            ;;
        3)
            echo "Enter student id: "
            read student_id_for_student
            
            return_function_value student $student_id_for_student 2
            student_return_value=$function_return_value

            if [ "$student_return_value" == 0 ]
            then
                echo "Student not exsist"
            else
                head_banner
                echo -e "\n=========================================="
                echo -e "= Welcome $student_return_value"
                echo -e "=========================================="

                view_single_student $student_id_for_student
            fi
            ;;
        4)
            exit
            ;;
        *)
            echo "Invalid Input"
            ;;
    esac
    # Ask user if they want to continue
    echo -e "\nDo you want to perform another operation [y/n]: "
    read choice
done