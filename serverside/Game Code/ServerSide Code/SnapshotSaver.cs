using System;
using System.Collections;
using System.Linq;
using PlayerIO.GameLibrary;

namespace ServerSide
{
    public class SnapshotSaver
    {
        private readonly int areaHeight;
        private readonly int areaWidth;
        private readonly BasicRoom gamelink;
        private readonly ArrayList outGoingSnapshots = new ArrayList();
        private readonly string spellName = "";

        public SnapshotSaver(BasicRoom gl, string spellNamea, int aareaWidth, int aareaHeight)
        {
            Console.WriteLine("SnapshotSaver inited");
            gamelink = gl;
            spellName = spellNamea;
            areaWidth = aareaWidth;
            areaHeight = aareaHeight;
        }

        /**
		 * Adds snaphshot to outgoing queue
		 */

        public void writeSnapshot(byte[] snapshot)
        {
            Console.WriteLine("writeSnapshot");
            outGoingSnapshots.Add(snapshot);
        }

        /**
		 * Sends all the data to DB
		 */

        public void finishRecording()
        {
            Console.WriteLine("finishRecording. spellName: " + spellName);
            //Load all existing objects 
            gamelink.PlayerIO.BigDB.LoadRange("Previews", "spellName", new object[] {spellName}, 0, 1000, 1000,
                onObjectsLoaded, onLoadingError);
        }

        private void onObjectsLoaded(DatabaseObject[] objects)
        {
            Console.WriteLine("objects loaded. Count: " + objects.Length);
            var toDelete = new string[objects.Length];
            foreach (DatabaseObject obj in objects)
            {
                toDelete[toDelete.Count(s => s != null)] = obj.Key;
            }
            if (toDelete.Count(s => s != null) > 0)
                gamelink.PlayerIO.BigDB.DeleteKeys("Previews", toDelete, createPreviewObjects);
            else
                createPreviewObjects();
        }

        private void onLoadingError(PlayerIOError err)
        {
            Console.WriteLine(err);
            gamelink.PlayerIO.ErrorLog.WriteError(err.Message, err.ErrorCode.ToString(), err.StackTrace, null);
            createPreviewObjects(); //go insert then
        }

        private void createPreviewObjects()
        {
            Console.WriteLine("Objects of same type were deleted.");
            int currentObjectSize = 0;
            int currentPartID = 1;
            var currentObject = new DatabaseObject();
            var currentFramesSet = new DatabaseArray();

            foreach (byte[] arr in outGoingSnapshots)
            {
                Console.WriteLine("Obj size: " + arr.Length);
                currentObjectSize += arr.Length;
                currentFramesSet.Add(arr);

                if (currentObjectSize > 400000)
                    //start new preview part if currentObject size is > 400kb (Playerio obj limmit size is 500kb)
                {
                    fillObject(currentObject, currentFramesSet);
                    gamelink.PlayerIO.BigDB.CreateObject("Previews", spellName + "_part_" + currentPartID, currentObject,
                        onObjCreated);
                    currentObject = new DatabaseObject();
                    currentFramesSet = new DatabaseArray();
                    currentPartID++;
                    currentObjectSize = 0;
                }
            }

            if (currentFramesSet.Count > 0) //create last object
            {
                fillObject(currentObject, currentFramesSet);
                gamelink.PlayerIO.BigDB.CreateObject("Previews", spellName + "_part_" + currentPartID, currentObject,
                    onObjCreated);
            }

            Console.WriteLine("Will write obhects with total size: " + outGoingSnapshots);
        }

        private void fillObject(DatabaseObject currentObject, DatabaseArray currentFramesSet)
        {
            currentObject.Set("spellName", spellName);
            currentObject.Set("frames", currentFramesSet);
            currentObject.Set("areaWidth", areaWidth);
            currentObject.Set("areaHeight", areaHeight);
        }

        private void onObjCreated(DatabaseObject obj)
        {
            Console.WriteLine("Object created: " + obj.Key);
        }
    }
}