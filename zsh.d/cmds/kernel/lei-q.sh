desc="lei query helper "
args=("--archive:The protocol address of the mail archive to query" \
	  "--mailbox:The local mailbox directory holding the query results" \
	  "--query:The full query string.")
help=("lei-q", "Creates a new mailbox populated with a specific mailbox query

 This script will query the {archive} and create a {mailbox} containing all
 messages which match the query.

 The 'lei' tool will remember the query and 'lei up {mailbox}' can be used to refresh the
 mailbox with new content matching the stored query.

 In the common case of using this tool against 'https://lore.kernel.org' the
 following query prefixes can be used:

 s:           match within Subject  e.g. s:'a quick brown fox'
 d:           match date-time range, git "approxidate" formats supported
 			 Open-ended ranges such as 'd:last.week..' and
 			 'd:..2.days.ago' are supported
 b:           match within message body, including text attachments
 nq:          match non-quoted text within message body
 q:           match quoted text within message body
 n:           match filename of attachment(s)
 t:           match within the To header
 c:           match within the Cc header
 f:           match within the From header
 a:           match within the To, Cc, and From headers
 tc:          match within the To and Cc headers
 l:           match contents of the List-Id header
 bs:          match within the Subject and body
 dfn:         match filename from diff
 dfa:         match diff removed (-) lines
 dfb:         match diff added (+) lines
 dfhh:        match diff hunk header context (usually a function name)
 dfctx:       match diff context lines
 dfpre:       match pre-image git blob ID
 dfpost:      match post-image git blob ID
 dfblob:      match either pre or post-image git blob ID
 patchid:     match 'git patch-id --stable' output
 rt:          match received time, like 'd:' if sender's clock was correct
 forpatchid:  the 'X-For-Patch-ID' mail header  e.g. forpatchid:stable
 
 changeid:    the 'X-Change-ID' mail header  e.g. changeid:stable
")

execute() {
}
