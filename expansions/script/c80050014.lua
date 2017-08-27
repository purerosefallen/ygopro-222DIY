--新的正义！神剑乱舞
function c80050014.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c80050014.spcon)
	e0:SetOperation(c80050014.spop)
	c:RegisterEffect(e0)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80050014,1))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c80050014.mtop)
	c:RegisterEffect(e4)
	--ATK Up
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(c80050014.atkval)
	c:RegisterEffect(e5)
	--multi attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EXTRA_ATTACK)
	e6:SetValue(c80050014.raval)
	c:RegisterEffect(e6)
	--destroy replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTarget(c80050014.reptg)
	c:RegisterEffect(e7)
	--Activate
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_REMOVE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e8:SetCode(EVENT_REMOVE)
	e8:SetTarget(c80050014.target)
	e8:SetOperation(c80050014.activate)
	c:RegisterEffect(e8)
end
function c80050014.filter1(c)
	return c:IsType(TYPE_MONSTER+TYPE_TRAP+TYPE_SPELL) and c:IsAbleToRemove()
end
function c80050014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c80050014.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function c80050014.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c80050014.filter1,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c80050014.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(80050014,3)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c80050014.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c80050014.raval(e,c)
	local oc=e:GetHandler():GetOverlayCount()
	return math.max(0,oc-1)
end
function c80050014.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x32d4) and c:IsAbleToRemoveAsCost() and c:IsLevelBelow(7)
end
function c80050014.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c80050014.filter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c80050014.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c80050014.filter,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c80050014.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0 and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>1 end
end
function c80050014.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g1=Duel.GetMatchingGroup(nil,1-tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if g1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_XMATERIAL)
		local sg1=g1:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg1)
		Duel.Overlay(c,sg1)
	end
	if g2:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		Duel.Overlay(c,sg2)
	end
end