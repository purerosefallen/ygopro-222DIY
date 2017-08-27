--死神·死亡本能
function c60150818.initial_effect(c)
	c:SetUniqueOnField(1,1,60150818)
	--summon limit
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e21:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e21:SetCode(EVENT_SPSUMMON_SUCCESS)
	e21:SetCondition(c60150818.regcon)
	e21:SetOperation(c60150818.regop)
	c:RegisterEffect(e21)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_SINGLE)
	e22:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e22:SetCode(EFFECT_SPSUMMON_CONDITION)
	e22:SetValue(c60150818.splimit)
	c:RegisterEffect(e22)
	--summon success
    local e23=Effect.CreateEffect(c)
	e23:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e23:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e23:SetCode(EVENT_SPSUMMON_SUCCESS)
    e23:SetOperation(c60150818.sumsuc)
    c:RegisterEffect(e23)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c60150818.xyzcon)
	e1:SetOperation(c60150818.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c60150818.condition)
	e2:SetOperation(c60150818.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_ACTIVATING)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c60150818.damcon)
	e4:SetOperation(c60150818.damop)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c60150818.indcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--cannot target
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetCondition(c60150818.indcon2)
	e6:SetValue(c60150818.tgvalue)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetCondition(c60150818.indcon3)
	e7:SetValue(c60150818.efilter)
	c:RegisterEffect(e7)
	--die
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1,60150818+EFFECT_COUNT_CODE_DUEL)
	e8:SetCondition(c60150818.descon)
	e8:SetCost(c60150818.descost)
	e8:SetTarget(c60150818.destg)
	e8:SetOperation(c60150818.desop)
	c:RegisterEffect(e8)
	if not c60150818.global_check then
		c60150818.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c60150818.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c60150818.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c60150818.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60150818.sumlimit)
	Duel.RegisterEffect(e1,tp)
end
function c60150818.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x3b23)
end
function c60150818.splimit(e,se,sp,st,spos,tgp)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ or Duel.GetFlagEffect(tgp,60150818)==0
end
function c60150818.sumsuc(e,tp,eg,ep,ev,re,r,rp)
    e:GetHandler():RegisterFlagEffect(6010818,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
end
function c60150818.spfilter(c,sc)
	return c:IsSetCard(0x3b23) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(sc)
end
function c60150818.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c60150818.spfilter,tp,LOCATION_MZONE,0,3,nil)
end
function c60150818.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c60150818.spfilter,tp,LOCATION_MZONE,0,3,3,nil)
	local tc=g:GetFirst()
	local sg=Group.CreateGroup()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end
function c60150818.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p1=false
	local p2=false
	while tc do
		if not tc:IsSetCard(0x3b23) then
			if tc:GetSummonPlayer()==0 then p1=true else p2=true end
		end
		tc=eg:GetNext()
	end
	if p1 then Duel.RegisterFlagEffect(0,60150818,RESET_PHASE+PHASE_END,0,1) end
	if p2 then Duel.RegisterFlagEffect(1,60150818,RESET_PHASE+PHASE_END,0,1) end
end
function c60150818.cfilter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c60150818.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60150818.cfilter,1,nil,1-tp) and e:GetHandler():GetOverlayGroup():IsExists(c60150818.filter2,1,nil)
end
function c60150818.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,60150818)
	local tc=eg:GetFirst()
	while tc do
		local dm=tc:GetLevel()
		local dm2=tc:GetRank()
		if tc:GetSummonLocation()==LOCATION_EXTRA then
			local g=Duel.GetLP(1-tp)
			Duel.SetLP(1-tp,g-(dm+dm2)*200)
		else
			local g=Duel.GetLP(1-tp)
			Duel.SetLP(1-tp,g-(dm+dm2)*100)
		end
		tc=eg:GetNext()
	end
end
function c60150818.filter2(c)
	return c:IsSetCard(0x3b23) and c:IsType(TYPE_XYZ)
end
function c60150818.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetOverlayGroup():IsExists(c60150818.filter2,1,nil) and ep~=tp and re:IsActiveType(TYPE_MONSTER)
end
function c60150818.damop(e,tp,eg,ep,ev,re,r,rp)
	
	Duel.Hint(HINT_CARD,0,60150818)
	local rc=re:GetHandler()
	local dm=rc:GetLevel()
	local dm2=rc:GetRank()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if (loc==LOCATION_HAND or loc==LOCATION_DECK or loc==LOCATION_OVERLAY 
		or loc==LOCATION_GRAVE or loc==LOCATION_REMOVED or loc==LOCATION_EXTRA) then
		local g=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,g-(dm+dm2)*200)
	else
		local g=Duel.GetLP(1-tp)
		Duel.SetLP(1-tp,g-(dm+dm2)*100)
	end
end
function c60150818.cfilter2(c)
	return c:IsFaceup() or c:IsFacedown()
end
function c60150818.indcon(c,e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)>=3
end
function c60150818.indcon2(c,e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)>=5
end
function c60150818.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c60150818.indcon3(c,e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)>=10
end
function c60150818.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c60150818.filter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function c60150818.descon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60150818.filter,tp,LOCATION_MZONE,0,nil)
	local atk=g:GetSum(Card.GetBaseAttack)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and atk>Duel.GetLP(1-tp) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x3b23)
end
function c60150818.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) and e:GetHandler():GetFlagEffect(6010818)==0 end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c60150818.dfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsDestructable()
end
function c60150818.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)>=10 then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c60150818.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150818,0))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150818,1))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60150818,2))
	Duel.SelectOption(1-tp,aux.Stringid(60150818,3))
	Duel.Hint(HINT_CARD,0,60150818)
	local g=Duel.GetLP(1-tp)
	Duel.SetLP(1-tp,0)
end