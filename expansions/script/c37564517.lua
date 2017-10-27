--Goodbye Yesterday
local m=37564517
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_desc_with_nanahira=true
function cm.initial_effect(c)
	--Senya.nntr(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.eqtg)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(cm.effcon)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(350)
	c:RegisterEffect(e3)
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e6:SetCountLimit(1,m)
	e6:SetCondition(cm.thcon)
	e6:SetTarget(cm.thtg)
	e6:SetOperation(cm.thop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetCode(EVENT_BATTLE_START)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(cm.descon)
	e7:SetTarget(cm.destg)
	e7:SetOperation(cm.desop)
	c:RegisterEffect(e7)
end
function cm.effcon(e,c)
	return c:IsCode(37564765)
end
function cm.eqfilter(c)
	return c:IsFaceup() and c:IsCode(37564765)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,cm.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,7,2850,2100,RACE_FAIRY,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,m,0,0x21,7,2850,2100,RACE_FAIRY,ATTRIBUTE_LIGHT) then
		--c:AddMonsterAttribute(0,0,0,0,0)
		c:AddMonsterAttribute(TYPE_EFFECT)
		Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP)
			c:AddMonsterAttributeComplete()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(37564765)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetHandler():GetEquipTarget()
	return tg and (Duel.GetAttacker()==tg or Duel.GetAttackTarget()==tg) and tg:GetOriginalCode()==37564765
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=c:GetEquipTarget():GetBattleTarget()
	if tc:IsRelateToBattle() then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end