--黄金の残滓
function c114100230.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c114100230.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1)
	e2:SetCondition(c114100230.setcon)
	e2:SetCost(c114100230.setcost)
	e2:SetTarget(c114100230.settg)
	e2:SetOperation(c114100230.setop)
	c:RegisterEffect(e2)
	--count
	if not c114100230.global_check then
		c114100230.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c114100230.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c114100230.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetOperation(c114100230.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c114100230.disop(e,tp,eg,ep,ev,re,r,rp)
	local atk=Duel.GetAttacker()
	local atg=Duel.GetAttackTarget()
	if atg==nil then return end
	local check=0
	if atk:GetControler()==tp then
		if atk:IsSetCard(0x221) and ( ( atg:IsType(TYPE_XYZ) or atg:IsLevelAbove(5) ) and atg:IsFaceup() ) then
			check=check+1
		end
	else
		if ( ( atk:IsType(TYPE_XYZ) or atk:IsLevelAbove(5) ) and atk:IsFaceup() ) and ( atg:IsSetCard(0x221) and atg:GetControler()==tp and atg:IsFaceup() ) then
			check=check+2
		end
	end
	if check==0 then return end
	local tc=Group.CreateGroup()
	local atk=Duel.GetAttackTarget()
	local atg=Duel.GetAttacker()
	if check==1 then tc:AddCard(atk) end
	if check==2 then tc:AddCard(atg) end
	if check==3 then tc:AddCard(atk) tc:AddCard(atg) end
	c114100230.monstop(e,tc)
end
function c114100230.monstop(e,g)
	local mg=g
	local c=e:GetHandler()
	local mgtc=mg:GetFirst()
	while mgtc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		mgtc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		mgtc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_TRIGGER)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		mgtc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_ATTACK_FINAL)
		e4:SetValue(mgtc:GetAttack()/2)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		mgtc:RegisterEffect(e4)
		--local e5=e4:Clone()
		--e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
		--e5:SetValue(mgtc:GetDefense()/2)
		--mgtc:RegisterEffect(e5)
		--mgtc=mg:GetNext()
	end
end

--sset global
function c114100230.sumfilter(c,tp)
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_EXTRA) and c:GetSummonPlayer()==tp
end
function c114100230.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local self=false
	local opp=false
	while tc do
		if c114100230.sumfilter(tc,tp) then self=true end
		if c114100230.sumfilter(tc,1-tp) then opp=true end
		tc=eg:GetNext()
	end
	if self then Duel.RegisterFlagEffect(tp,114100230,RESET_PHASE+PHASE_END,0,1) end
	if opp then Duel.RegisterFlagEffect(1-tp,114100230,RESET_PHASE+PHASE_END,0,1) end
end
--
function c114100230.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,114100230)>0
end
function c114100230.setfilter(c)
	return c:IsSetCard(0x221) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c114100230.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c114100230.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c114100230.setfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c114100230.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c114100230.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,c)
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end