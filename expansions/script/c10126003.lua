--反骨的勇士 勇
function c10126003.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10126003,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c10126003.eqtg)
	e1:SetOperation(c10126003.eqop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)   
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10126003,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_EQUIP)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,10126003)
	e3:SetCondition(c10126003.condition)
	e3:SetCost(c10126003.cost)
	e3:SetTarget(c10126003.target)
	e3:SetOperation(c10126003.operation)
	c:RegisterEffect(e3)  
end
function c10126003.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return re~=e and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c10126003.desfilter1(c,tp)
	local ec=c:GetEquipTarget()
	return ec and ec:IsControler(tp) 
end
function c10126003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126003.desfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,2,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c10126003.desfilter1,tp,LOCATION_SZONE,LOCATION_SZONE,2,2,nil,tp)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c10126003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=re:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if tc:IsAbleToChangeControler() and tc:IsFaceup() and tc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
	end
end
function c10126003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local tc=re:GetHandler()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then
	 if (tc:IsType(TYPE_EQUIP) and not tc:CheckEquipTarget(c)) or not Duel.Equip(1-tp,tc,c,false) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c10126003.eqlimit)
			tc:RegisterEffect(e1)
	end
end
function c10126003.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10126003.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10126003.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,0,0)
end
function c10126003.eqfilter(c)
	return c:IsAbleToChangeControler() and c:IsFaceup()
end
function c10126003.eqlimit(e,c)
	return e:GetOwner()==c
end
function c10126003.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c10126003.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if not g then return end
	local tc=g:GetFirst()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then Duel.SendtoGrave(tc,REASON_EFFECT) return end
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c10126003.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(200)
		tc:RegisterEffect(e2)
end