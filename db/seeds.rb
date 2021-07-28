User.create(
  [
    {
      firstName: "Snow",
      lastName: "Man",
      password: "snow123",
      email: "snowman@gmail.com",
      country: "iceland"
    },{
    firstName: "Jack",
    lastName: "Frost",
    password: "frozen123",
    email: "frozen@gmail.com",
    country: "North Pole"
    }])

Project.create(
  [
    {
      title: "Busan Project",
      description:"Haeundae Beach",
      projectType: "external",
      location: "Haeundae, Busan",
      thumbnail: "/uploads/project/thumbnail/9/kitten.jpeg",
      userEmail: "frozen@gmail.com"
    },{
    title: "Changwon Project",
    description:"Changwon Beach",
    projectType: "external",
    location: "Changwon, Busan",
    thumbnail: "/uploads/project/thumbnail/9/kitten.jpeg",
    userEmail: "frozen@gmail.com"
    },
  {
  title: "Ski Project",
    description:"Ski Resort",
    projectType: "international",
    location: "Pyeongchang",
    thumbnail: "/uploads/project/thumbnail/9/kitten.jpeg",
    userEmail: "snowman@gmail.com"
    },
    {
      title: "Daegu Project",
      description:"Daegu Tower",
      projectType: "in_house",
      location: "Daegu",
      thumbnail: "/uploads/project/thumbnail/9/kitten.jpeg",
      userEmail: "snowman@gmail.com"
    }
  ])

Content.create(
  [{
     projectId:1,
     title: "Lorem Ipsum",
     body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
       Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
       Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
   },
   {projectId:1,
    title: "Consectetur Adipiscing Elit",
    body: "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
        Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."},

   {projectId:3,
    title: "De Finibus Bonorum et Malorum",
    body: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium
         voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident,
          similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga."}]
)