--口袋妖怪 Mega巨钳螳螂
function c80000168.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,10000000)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1) 
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80000168,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c80000168.eqtg)
	e2:SetOperation(c80000168.eqop)
	c:RegisterEffect(e2)	
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetTarget(c80000168.desreptg)
	e3:SetOperation(c80000168.desrepop)
	c:RegisterEffect(e3)
	--multi attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(c80000168.val)
	c:RegisterEffect(e4)
	--half damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e5:SetCondition(c80000168.dcon)
	e5:SetOperation(c80000168.dop)
	c:RegisterEffect(e5)
	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(80000168,1))
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(c80000168.eqcon1)
	e6:SetTarget(c80000168.eqtg1)
	e6:SetOperation(c80000168.eqop1)
	c:RegisterEffect(e6)
	--negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80000168,2))
	e7:SetCategory(CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_CHAINING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c80000168.discost)
	e7:SetCondition(c80000168.discon)
	e7:SetTarget(c80000168.distg)
	e7:SetOperation(c80000168.disop)
	c:RegisterEffect(e7)
end
function c80000168.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(Card.IsAbleToGraveAsCost,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,Card.IsAbleToGraveAsCost,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c80000168.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(c) then return false end
	return Duel.IsChainDisablable(ev) and loc~=LOCATION_DECK 
end
function c80000168.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c80000168.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.NegateEffect(ev)
end
function c80000168.dcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetEquipCount()>0 and ep~=tp and c==Duel.GetAttacker() and Duel.GetAttackTarget()==nil
end
function c80000168.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/4)
end
function c80000168.val(e,c)
	return c:GetEquipCount()
end
function c80000168.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c80000168.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c80000168.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c80000168.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local fc=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c80000168.filter,tp,LOCATION_GRAVE,0,1,fc,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function c80000168.eqlimit(e,c)
	return e:GetOwner()==c
end
function c80000168.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tg0=g:Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if tg0:GetCount()==0 or ft<=0 then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local tg=nil
		if ft<tg0:GetCount() then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			tg=tg0:FilterSelect(tp,c80000168.filter,ft,ft,nil)
		else
			tg=tg0:Clone()
		end
		if tg:GetCount()>0 then
			local tc=tg:GetFirst()
			while tc do
				Duel.Equip(tp,tc,c,false,true)
				tc:RegisterFlagEffect(80000168,RESET_EVENT+0x1fe0000,0,0)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetValue(c80000168.eqlimit)
				tc:RegisterEffect(e1)
				tc=tg:GetNext()
			end
			Duel.EquipComplete()
		end
	else
		Duel.SendtoGrave(tg0,REASON_EFFECT)
	end
end
function c80000168.repfilter(c)
	return c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function c80000168.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(c80000168.repfilter,1,nil)
	end
	if Duel.SelectYesNo(tp,aux.Stringid(80000168,1)) then
		local g=c:GetEquipGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,c80000168.repfilter,1,1,nil)
		Duel.SetTargetCard(sg)
		return true
	else return false end
end
function c80000168.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.SendtoGrave(tg,REASON_EFFECT+REASON_REPLACE)
end
function c80000168.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_GRAVE) and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE)
end
function c80000168.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c80000168.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c80000168.eqlimit1)
		tc:RegisterEffect(e1)
	end
end
function c80000168.eqlimit1(e,c)
	return e:GetOwner()==c
end

