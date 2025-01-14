#!/usr/bin/env roseus

(ros::load-ros-manifest "aero_startup")

(ros::roseus "hand_interface")

(ros::wait-for-service "/aero_hand_controller")

(defmethod aero-upper-interface
  (:grasp (arm &key (tfail 0.8) (twarn -0.9))
    (let (req
	  res
	  )
      (setq req (instance
		 aero_startup::AeroHandControllerRequest
		 :init))
      (cond ((eq arm :larm) (send req :hand "left"))
	    ((eq arm :rarm) (send req :hand "right"))
	    ((eq arm :arms) (send req :hand "both"))
	    )
      (send req :command "grasp")
      (send req :thre_fail tfail)
      (send req :thre_warn twarn)
      (setq res (ros::service-call "/aero_hand_controller" req))
      (print (send res :status))
      ))
  (:ungrasp (arm)
    (let (req
	  res
	  )
      (setq req (instance
		 aero_startup::AeroHandControllerRequest
		 :init))
      (cond ((eq arm :larm) (send req :hand "left"))
	    ((eq arm :rarm) (send req :hand "right"))
	    ((eq arm :arms) (send req :hand "both"))
	    )
      (send req :command "ungrasp")
      (setq res (ros::service-call "/aero_hand_controller" req))
      (print (send res :status))
      ))
  (:grasp-angle (arm angle)
;; rarm :  open-limit 50 close-limit -50
;; larm :  open-limit -50  close-limit 50

    (let (req
	  res
	  )
      (setq req (instance
		 aero_startup::AeroHandControllerRequest
		 :init))
      (cond ((eq arm :larm) (progn (send req :hand "left") (send req :larm_angle angle)))
	    ((eq arm :rarm) (progn (send req :hand "right") (send req :rarm_angle angle)))
	    )
      (send req :command "grasp-angle")
      (setq res (ros::service-call "/aero_hand_controller" req))
      (print (send res :status))
      ))
  );; end of defmethod aero-upper-interface
