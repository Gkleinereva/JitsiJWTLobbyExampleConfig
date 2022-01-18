// Should be retrieved from an API endpoint on your server prior to meeting initialization
let jitsiJwt;

const api = new JitsiMeetExternalAPI("meet.example.com", {
  roomName: "<conferenceId>",
  width: '100%',
  height: '100%', 
  parentNode: document.querySelector('#jitsiContainer'),

  // Include the jwt in the options passed to the constructor
  jwt: jitsiJwt, 
});

api.addEventListener('participantRoleChanged', (function(event) {
  if(event.role === 'moderator') {
    this.api.executeCommand('toggleLobby', true);
  }
}));