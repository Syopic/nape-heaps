package nape.callbacks;
import zpp_nape.Const;
import zpp_nape.ID;
import zpp_nape.util.Array2;
import zpp_nape.util.Circular;
import zpp_nape.util.DisjointSetForest;
import zpp_nape.util.FastHash;
import zpp_nape.util.Flags;
import zpp_nape.util.Lists;
import zpp_nape.util.Math;
import zpp_nape.util.Names;
import zpp_nape.util.Pool;
import zpp_nape.util.Queue;
import zpp_nape.util.RBTree;
import zpp_nape.util.Debug;
import zpp_nape.util.UserData;
import zpp_nape.util.WrapLists;
import zpp_nape.space.Broadphase;
import zpp_nape.space.DynAABBPhase;
import zpp_nape.space.SweepPhase;
import zpp_nape.shape.Circle;
import zpp_nape.shape.Edge;
import zpp_nape.shape.Polygon;
import zpp_nape.shape.Shape;
import zpp_nape.phys.Body;
import zpp_nape.phys.Compound;
import zpp_nape.phys.FeatureMix;
import zpp_nape.phys.FluidProperties;
import zpp_nape.phys.Interactor;
import zpp_nape.phys.Material;
import zpp_nape.geom.AABB;
import zpp_nape.geom.Collide;
import zpp_nape.geom.Convex;
import zpp_nape.geom.ConvexRayResult;
import zpp_nape.space.Space;
import zpp_nape.geom.Cutter;
import zpp_nape.geom.Geom;
import zpp_nape.geom.GeomPoly;
import zpp_nape.geom.Mat23;
import zpp_nape.geom.MarchingSquares;
import zpp_nape.geom.MatMN;
import zpp_nape.geom.MatMath;
import zpp_nape.geom.Monotone;
import zpp_nape.geom.PolyIter;
import zpp_nape.geom.PartitionedPoly;
import zpp_nape.geom.Ray;
import zpp_nape.geom.Simplify;
import zpp_nape.geom.Simple;
import zpp_nape.geom.SweepDistance;
import zpp_nape.geom.Vec2;
import zpp_nape.geom.Vec3;
import zpp_nape.geom.Triangular;
import zpp_nape.geom.VecMath;
import zpp_nape.dynamics.Contact;
import zpp_nape.dynamics.InteractionFilter;
import zpp_nape.dynamics.InteractionGroup;
import zpp_nape.dynamics.SpaceArbiterList;
import zpp_nape.constraint.AngleJoint;
import zpp_nape.constraint.Constraint;
import zpp_nape.dynamics.Arbiter;
import zpp_nape.constraint.DistanceJoint;
import zpp_nape.constraint.LinearJoint;
import zpp_nape.constraint.MotorJoint;
import zpp_nape.constraint.PivotJoint;
import zpp_nape.constraint.LineJoint;
import zpp_nape.constraint.UserConstraint;
import zpp_nape.constraint.WeldJoint;
import zpp_nape.constraint.PulleyJoint;
import zpp_nape.callbacks.Callback;
import zpp_nape.callbacks.CbSetPair;
import zpp_nape.callbacks.CbType;
import zpp_nape.callbacks.CbSet;
import zpp_nape.callbacks.OptionType;
import zpp_nape.callbacks.Listener;
import nape.Config;
import nape.TArray;
import nape.util.Debug;
import nape.util.BitmapDebug;
import nape.space.Broadphase;
import nape.util.ShapeDebug;
import nape.shape.Circle;
import nape.shape.Edge;
import nape.shape.EdgeIterator;
import nape.shape.EdgeList;
import nape.space.Space;
import nape.shape.Polygon;
import nape.shape.ShapeIterator;
import nape.shape.ShapeList;
import nape.shape.ShapeType;
import nape.shape.ValidationResult;
import nape.shape.Shape;
import nape.phys.BodyIterator;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.phys.CompoundIterator;
import nape.phys.CompoundList;
import nape.phys.FluidProperties;
import nape.phys.GravMassMode;
import nape.phys.InertiaMode;
import nape.phys.Interactor;
import nape.phys.InteractorIterator;
import nape.phys.InteractorList;
import nape.phys.MassMode;
import nape.phys.Body;
import nape.phys.Material;
import nape.geom.ConvexResult;
import nape.geom.ConvexResultIterator;
import nape.geom.ConvexResultList;
import nape.geom.AABB;
import nape.geom.Geom;
import nape.geom.GeomPolyIterator;
import nape.geom.GeomPolyList;
import nape.geom.GeomVertexIterator;
import nape.geom.IsoFunction;
import nape.geom.MarchingSquares;
import nape.geom.GeomPoly;
import nape.geom.MatMN;
import nape.geom.Mat23;
import nape.geom.Ray;
import nape.geom.RayResultIterator;
import nape.geom.RayResultList;
import nape.geom.RayResult;
import nape.geom.Vec2Iterator;
import nape.geom.Vec2List;
import nape.geom.Vec3;
import nape.geom.Winding;
import nape.dynamics.Arbiter;
import nape.dynamics.ArbiterIterator;
import nape.geom.Vec2;
import nape.dynamics.ArbiterList;
import nape.dynamics.ArbiterType;
import nape.dynamics.Contact;
import nape.dynamics.ContactIterator;
import nape.dynamics.ContactList;
import nape.dynamics.FluidArbiter;
import nape.dynamics.CollisionArbiter;
import nape.dynamics.InteractionFilter;
import nape.dynamics.InteractionGroupIterator;
import nape.dynamics.InteractionGroupList;
import nape.dynamics.InteractionGroup;
import nape.constraint.AngleJoint;
import nape.constraint.ConstraintIterator;
import nape.constraint.ConstraintList;
import nape.constraint.DistanceJoint;
import nape.constraint.LinearJoint;
import nape.constraint.Constraint;
import nape.constraint.LineJoint;
import nape.constraint.PivotJoint;
import nape.constraint.MotorJoint;
import nape.constraint.PulleyJoint;
import nape.constraint.UserConstraint;
import nape.constraint.WeldJoint;
import nape.callbacks.BodyCallback;
import nape.callbacks.Callback;
import nape.callbacks.BodyListener;
import nape.callbacks.CbEvent;
import nape.callbacks.CbTypeIterator;
import nape.callbacks.CbTypeList;
import nape.callbacks.ConstraintCallback;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.ConstraintListener;
import nape.callbacks.InteractionListener;
import nape.callbacks.ListenerIterator;
import nape.callbacks.ListenerList;
import nape.callbacks.ListenerType;
import nape.callbacks.Listener;
import nape.callbacks.OptionType;
import nape.callbacks.PreFlag;
import nape.callbacks.PreCallback;
import nape.callbacks.PreListener;
/**
 * Enumeration of Interaction types.
 */
@:final#if nape_swc@:keep #end
class InteractionType{
    /**
     * @private
     */
    public function new(){
        #if(!NAPE_RELEASE_BUILD)
        if(!ZPP_Flags.internal)throw "Error: Cannot instantiate "+"InteractionType"+" derp!";
        #end
    }
    /**
     * @private
     */
    @:keep public function toString(){
        if(false)return "";
        
        else if(this==COLLISION)return"COLLISION";
        else if(this==SENSOR)return"SENSOR";
        else if(this==FLUID)return"FLUID";
        else if(this==ANY)return"ANY";
        else return "";
    }
    /**
     * Collision interaction type.
     */
    #if nape_swc@:isVar #end
    public static var COLLISION(get,never):InteractionType;
    inline static function get_COLLISION(){
        if(ZPP_Flags.InteractionType_COLLISION==null){
            ZPP_Flags.internal=true;
            ZPP_Flags.InteractionType_COLLISION=new InteractionType();
            ZPP_Flags.internal=false;
        }
        return ZPP_Flags.InteractionType_COLLISION;
    }
    /**
     * Sensor interaction type.
    ""*/#if nape_swc@:isVar #end
    public static var SENSOR(get,never):InteractionType;
    inline static function get_SENSOR(){
        if(ZPP_Flags.InteractionType_SENSOR==null){
            ZPP_Flags.internal=true;
            ZPP_Flags.InteractionType_SENSOR=new InteractionType();
            ZPP_Flags.internal=false;
        }
        return ZPP_Flags.InteractionType_SENSOR;
    }
    /**
     * Fluid interaction type.
     */
    #if nape_swc@:isVar #end
    public static var FLUID(get,never):InteractionType;
    inline static function get_FLUID(){
        if(ZPP_Flags.InteractionType_FLUID==null){
            ZPP_Flags.internal=true;
            ZPP_Flags.InteractionType_FLUID=new InteractionType();
            ZPP_Flags.internal=false;
        }
        return ZPP_Flags.InteractionType_FLUID;
    }
    /**
     * Special enum corresponding to 'all' interaction types.
     */
    #if nape_swc@:isVar #end
    public static var ANY(get,never):InteractionType;
    inline static function get_ANY(){
        if(ZPP_Flags.InteractionType_ANY==null){
            ZPP_Flags.internal=true;
            ZPP_Flags.InteractionType_ANY=new InteractionType();
            ZPP_Flags.internal=false;
        }
        return ZPP_Flags.InteractionType_ANY;
    }
}
