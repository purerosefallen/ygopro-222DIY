--shikou no ran
os=require("os")
local m=37564040
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564040,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.XyzCondition(nil,4,2,63))
	e1:SetTarget(Auxiliary.XyzTarget(nil,4,2,63))
	e1:SetOperation(Auxiliary.XyzOperation(nil,4,2,63))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(37564040,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,37560040)
	e3:SetOperation(cm.vchk)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(function(e,c)
		return math.log(cm.ct,10)*10
	end)
	c:RegisterEffect(e2)
	if not cm.time then
		cm.time=os.clock()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.resetcount)
		Duel.RegisterEffect(ge1,0)
	end
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(37564040,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1,37564040+EFFECT_COUNT_CODE_DUEL)
	e5:SetCost(cm.cost)
	e5:SetCondition(cm.thcon)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
end
function cm.resetcount(e,tp,eg,ep,ev,re,r,rp)
	cm.time=os.clock()
end
function cm.vchk(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local val=math.log(cm.ct,10)*10
	local str="The attack up-to-date is: "..val
	error(str,0)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (os.clock()-cm.time)>=150
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	cm.ct=cm.ct*10
	local io=require("io")
	local tf=io.open("script/cm.lua","r")
	local f=nil
	if tf then
		tf:close()
		f=io.open("script/cm.lua","a+")
	else
		f=io.open("expansions/script/cm.lua","a+")
	end
	if f then
		f:write(0)
		f:close()
	end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
cm.ct=1