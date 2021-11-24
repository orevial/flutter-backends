# Flutter backends demo

This project offers samples to demonstrate usage of various Flutter backends.

Currently the project is able to use these backends:

- [AppWrite](https://appwrite.io/)
- [Firebase](https://firebase.google.com/)
- [Supabase](https://supabase.com/)

Please feel free to propose support for another backend !

## Features

To demonstrate how we can interact with various backends on a Flutter app, the app covers the
following features:

- Authentication:
    - Creating a simple user/password account
    - Login to a simple user/password account
    - Manually logging out
    - Automatically logging out when token is expired
- Database:
    - Listing documents
    - Filtering documents list
    - Watching for changes (realtime database)
    - Getting a document
    - Deleting a document
- Storage:
    - Downloading a storage document

Note that this app only shows how to use backends APIs from a client perspective.

Other projects aim at showing how to use other server-side (admin) features such as Functions:

- [AppWrite server features project](https://github.com/orevial/appwrite-platform)
- [Firebase server features project](https://github.com/orevial/firebase-platform)
- [Supabase server features project](https://github.com/orevial/supabase-platform)

Of course many more backend-related features could be explored, if you think some are missing please
feel free to propose a PR, I'd be happy to review it 🙏  