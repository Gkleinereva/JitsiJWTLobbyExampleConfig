// Should be retrieved from an API endpoint prior to meeting initialization
declare jitsiJwt;

const api = new new JitsiMeetExternalAPI("meet.example.com", {
  roomName: "<conferenceId>",
  width: '100%',
  height: '100%', 
  parentNode: document.querySelector('#jitsiContainer'),

  jwt: jitsiJwt, 
});

api.addEventListener('participantRoleChanged', (function(event) {
  if(event.role === 'moderator') {
    this.api.executeCommand('toggleLobby', true);
  }
}));