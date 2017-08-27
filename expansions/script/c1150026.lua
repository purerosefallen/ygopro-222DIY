--迷失于深林中
function c1150026.initial_effect(c)
--
	c:SetUniqueOnField(1,1,1150026)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	e1:SetCondition(c1150026.con1)
	c:RegisterEffect(e1)	  
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_FLIP)
	e2:SetCode(EVENT_CUSTOM+1150026)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetTarget(c1150026.tg2)
	e2:SetOperation(c1150026.op2)
	c:RegisterEffect(e2)
	if not c1150026.gchk then
		c1150026.gchk=true
		c1150026[0]=2
		c1150026[1]=2
		local e2_1=Effect.GlobalEffect()
		e2_1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2_1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2_1:SetCondition(c1150026.con2_1)
		e2_1:SetOperation(c1150026.op2_1)
		Duel.RegisterEffect(e2_1,0)
	end 
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(1)
	e3:SetCondition(c1150026.con3)
	c:RegisterEffect(e3)
end
--
function c1150026.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity() 
end
--
c1150026.count_available=1150026
--
function c1150026.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c1150026.f2_1,rp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c1150026.f2_1(c)
	return c.count_available==1150026 and c:IsFaceup()
end
--
function c1150026.op2_1(e,tp,eg,ep,ev,re,r,rp)
	if c1150026[rp]<=1 then
		c1150026[rp]=2
		Duel.RaiseEvent(eg,EVENT_CUSTOM+1150026,re,r,rp,ep,ev)
	else 
		c1150026[rp]=c1150026[rp]-1 
	end
end
--
function c1150026.tfilter2(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c1150026.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c1150026.tfilter2,1,nil) end
	local g=eg:Filter(c1150026.tfilter2,nil)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
--
function c1150026.op2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		local g=eg:Filter(c1150026.tfilter2,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end
--
function c1150026.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end
--
