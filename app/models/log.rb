class Log < ApplicationRecord
  MSG_SEND    = "msg_send"
  RECOM_SEND  = "recom_send"
  ANSW_SHOW   = "answ_show"
  EDGE_SHOW   = "edge_show"
  EDGE_REJECT = "edge_reject"
  ANSW_SEARCH = "answ_search"
  ANS_NEW_TRY = "answ_new_try"
  ANS_SEND    = "answ_send"

  belongs_to :user

  validates_presence_of :operation
end
