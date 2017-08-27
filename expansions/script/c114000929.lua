--★叛逆の悪魔 暁美ほむら
function c114000929.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c114000929.retcon)
	e1:SetOperation(c114000929.retop)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,1)
	e2:SetCondition(c114000929.tgcon)
	e2:SetValue(c114000929.aclimit)
	c:RegisterEffect(e2)
	--add setcode
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetValue(0xcabb)
	c:RegisterEffect(e3)
end
function c114000929.retcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return re 
	and ( rc:IsSetCard(0xcabb) or rc:IsSetCard(0x223) or rc:IsSetCard(0x224) --or rc:IsSetCard(0x5047)
	or rc:IsCode(36405256) or rc:IsCode(54360049) or rc:IsCode(37160778) or rc:IsCode(27491571) or rc:IsCode(80741828) or rc:IsCode(90330453) --0x223
	or rc:IsCode(32751480) or rc:IsCode(78010363) or rc:IsCode(39432962) or rc:IsCode(67511500) or rc:IsCode(62379337) or rc:IsCode(23087070) or rc:IsCode(17720747) or rc:IsCode(98358303) or rc:IsCode(91584698) ) --0x224
	and e:GetHandler():GetSummonType()~=SUMMON_TYPE_PENDULUM
end
function c114000929.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsFaceup()
end
function c114000929.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--return to hand
	local sg=Duel.GetMatchingGroup(c114000929.tgfilter,tp,LOCATION_REMOVED,0,nil)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=sg:Select(tp,1,1,nil)
		Duel.HintSelection(tg)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
	local sg2=Duel.GetMatchingGroup(c114000929.tgfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	--return to deck
	if sg2:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(sg2,nil,2,REASON_EFFECT)
	end
end
--cannot activate
function c114000929.tgcon(e)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+600)
end
function c114000929.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e) and re:GetOwner()~=e:GetOwner()
end