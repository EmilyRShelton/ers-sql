SELECT
	dnc_users.firstname || ' ' || dnc_users.lastname as Full_Name,
	regionname as region,
	eventname,
	count(rsvp_date) as recruited_all_times,
	sum(attended) as completed_all_times,
	count(CASE WHEN ((RSVP_date >= CURRENT_DATE - 14) AND (RSVP_date < CURRENT_DATE) AND (eventdate >= CURRENT_DATE - 14) AND (eventdate < CURRENT_DATE)) THEN RSVP_date ELSE null END) AS recruited_two_weeks,
	sum(CASE WHEN ((RSVP_date >= CURRENT_DATE - 14) AND (RSVP_date < CURRENT_DATE) AND (eventdate >= CURRENT_DATE - 14) AND (eventdate < CURRENT_DATE)) THEN attended ELSE null END) AS completed_two_weeks
FROM
	co18_polis_vansync_live.event_attendees_live
left join co18_polis_vansync_live.dnc_eventsignups on
	event_attendees_live.myc_vanid = dnc_eventsignups.vanid
	and event_attendees_live.eventid = dnc_eventsignups.eventid
	and event_attendees_live.shiftid = dnc_eventsignups.eventshiftid
left join co18_polis_vansync_live.dnc_users on
	dnc_eventsignups.createdby = dnc_users.userid
left join co18_polis_vansync_live.dnc_activityregions ON
	event_attendees_live.myc_vanid = dnc_activityregions.vanid
where
	canvassedby = 1579554
	and eventname IN ( 'Canvass',
	'Phone Bank',
	'Petitioning',
	'Voter Registration' )
	and mrr_statusname in ('Completed',
	'Declined',
	'No Show',
	'Scheduled',
	'Confirmed',
	'Left Msg')
	and dnc_eventsignups.datesuppressed is null
	and volunteeractivityname = 'Volunteer'
GROUP BY
	1,
	2,
	3;