--蔷薇兽/爆裂形态
function c80023038.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),99,99,c80023038.ovfilter,aux.Stringid(80023038,99),5)
	c:EnableReviveLimit()  
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)	
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80023038,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c80023038.cost)
	e3:SetTarget(c80023038.target)
	e3:SetOperation(c80023038.activate)
	c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
	c:RegisterEffect(e4)
	--control
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_CONTROL)
	e5:SetDescription(aux.Stringid(80023038,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c80023038.ctcost)
	e5:SetTarget(c80023038.cttg)
	e5:SetOperation(c80023038.ctop)
	c:RegisterEffect(e5)
end
function c80023038.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c80023038.ovfilter(c)
	return c:IsFaceup() and c:IsCode(80023036) and Duel.GetLP(tp)<=2000
end
function c80023038.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c80023038.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c80023038.filter,tp,LOCATION_ONFIELD,0,1,c) end
	local g1=Duel.GetMatchingGroup(c80023038.filter,tp,LOCATION_ONFIELD,0,c)
	local g2=Duel.GetMatchingGroup(c80023038.filter,tp,0,LOCATION_ONFIELD,nil)
	local ct1=g1:GetCount()
	local ct2=g2:GetCount()
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,ct1+((ct1>ct2) and ct2 or ct1),0,0)
end
function c80023038.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c80023038.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local ct1=Duel.Destroy(g1,REASON_EFFECT)
	if ct1==0 then return end
	local g2=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local ct2=g2:GetCount()
	if ct2==0 then return end
	Duel.BreakEffect()
	if ct2<=ct1 then
		local ctw=Duel.Destroy(g2,REASON_EFFECT)
		Duel.Damage(1-tp,(ct1+ctw)*500,REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g3=g2:Select(tp,ct1,ct1,nil)
		Duel.HintSelection(g3)
		local ctw=Duel.Destroy(g3,REASON_EFFECT)
		Duel.Damage(1-tp,(ct1+ctw)*500,REASON_EFFECT)
	end
end
function c80023038.ctfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c80023038.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=math.min(Duel.GetMatchingGroupCount(c80023038.ctfilter,tp,0,LOCATION_MZONE,nil),Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL),c:GetOverlayCount(),999)
	if chk==0 then return rt>0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function c80023038.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function c80023038.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c80023038.atktg)
	e1:SetLabel(c:GetFieldID())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local ct=math.min(e:GetLabel(),Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_CONTROL))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,c80023038.ctfilter,tp,0,LOCATION_MZONE,ct,ct,nil)
	Duel.GetControl(g,tp,PHASE_END,1)
	local og=Duel.GetOperatedGroup()
	local tc=og:GetFirst()
	while tc do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_PLANT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetCondition(c80023038.rdcon)
		e3:SetOperation(c80023038.rdop)
		tc:RegisterEffect(e3)
		tc=og:GetNext()
	end
end
function c80023038.atktg(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c80023038.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c80023038.rdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end