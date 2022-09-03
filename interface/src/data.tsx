import { Tree } from "./types/types"

export const mockOrgTreeList: Tree = [
    {
      label: "Liberty Health",
      id: "1",
      branches: [
        {
          label: "Pacific Northwest",
          id: "2",
          branches: [
            {
              label: "East Portland Clinic",
              id: "3",
              branches: [],
            },
            {
              label: "Beaverton / Tigard",
              id: "4",
              branches: []
            },
            {
              label: "Lake Oswego Regency",
              id: "5",
              branches: []
            }
          ]
        },
        {
          label: "Alaska",
          id: "6",
          branches: []
        }
      ]
    },
    {
      label: "Northstar Alliance",
      id: "7",
      branches: [
        {
          label: "Chicago",
          id: "8",
          branches: [
            {
              label: "Southwest Region",
              id: "9",
              branches: [
                {
                  label: "Desplains",
                  id: "10",
                  branches: []
                },
                {
                  label: "Oak Lawn",
                  id: "11",
                  branches: []
                }
              ]
            },
            {
              label: "Northwest Region",
              id: "12",
              branches: [
                {
                  label: "East Morland",
                  id: "13",
                  branches: []
                },
              ]
            }
          ]
        },
        {
          label: "New York",
          id: "14",
          branches: [
            {
              label: "Manhattan",
              id: "15",
              branches: []
            },
            {
              label: "Queens",
              id: "16",
              branches: []
            },
            {
              label: "5372 Arlington Heights",
              id: "17",
              branches: []
            },
            {
              label: "The Earlmore Institute of Health",
              id: "18",
              branches: []
            },
          ]
        }
      ]
    }
  ]
  