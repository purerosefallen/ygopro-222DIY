--★光と闇の魔法少女 えれな
function c114001001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c114001001.spcon)
	e1:SetOperation(c114001001.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c114001001.atkcon)
	e2:SetValue(c114001001.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c114001001.spfilter(c)
	return c:IsSetCard(0xcabb) and c:IsAbleToRemoveAsCost() and ( c:IsFaceup() or c:IsLocation(LOCATION_GRAVE+LOCATION_HAND) )
end
function c114001001.spfilter2(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsSetCard(0xcabb) and c:IsAbleToRemoveAsCost()
end
function c114001001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c114001001.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,c)
	local g2=Duel.GetMatchingGroup(c114001001.spfilter2,c:GetControler(),LOCATION_EXTRA,0,nil)
	local c1=g1:GetCount()
	local c2=g2:GetCount()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c1+c2>=2
end
function c114001001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(c114001001.spfilter,c:GetControler(),LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,c)
	local g2=Duel.GetMatchingGroup(c114001001.spfilter2,c:GetControler(),LOCATION_EXTRA,0,nil)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rm=g1:Select(tp,2,2,nil)
	Duel.Remove(rm,POS_FACEUP,REASON_COST)
end

function c114001001.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end

function c114001001.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER)
end

function c114001001.val(e,c)
	return Duel.GetMatchingGroupCount(c114001001.atkfilter,c:GetControler(),0,LOCATION_REMOVED,nil)*-300
end