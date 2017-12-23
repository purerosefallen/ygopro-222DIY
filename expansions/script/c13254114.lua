--镰鼬飞球
function c13254114.initial_effect(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(13254031)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13254114,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,13254114)
	e2:SetCondition(c13254114.thcon)
	e2:SetTarget(c13254114.thtg)
	e2:SetOperation(c13254114.thop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13254114,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,23254114)
	e3:SetCondition(c13254114.tgcon)
	e3:SetTarget(c13254114.tgtg)
	e3:SetOperation(c13254114.tgop)
	c:RegisterEffect(e3)
	
end
function c13254114.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 
end
function c13254114.cfilter1(c,e,tp)
	return c:IsSetCard(0x356) and not c:IsPublic() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254114.cfilter2(c,e,tp)
	return c:IsSetCard(0x356) and not c:IsPublic() and c:IsType(TYPE_MONSTER)
end
function c13254114.cfilter3(c,e,tp,ft)
	return c:IsSetCard(0x356) and not c:IsPublic() and c:IsType(TYPE_MONSTER) and ((c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and ft>0) or not c:IsAttribute(ATTRIBUTE_WIND))
end
function c13254114.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c13254114.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local cc1=Duel.GetMatchingGroupCount(c13254114.cfilter1,tp,LOCATION_HAND,0,c,e,tp)
	local cg2=Duel.GetMatchingGroup(c13254114.cfilter2,tp,LOCATION_HAND,0,c,e,tp)
	local cc2=cg2:GetCount()
	ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c13254114.thfilter(chkc) end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingTarget(c13254114.thfilter,tp,0,LOCATION_ONFIELD,1,nil) and cc2>=2 and cc2-cc1>=1+2-ft end
	local cg=Group.CreateGroup()
	local sg=Group.CreateGroup()
	local i=0
	while i<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		sg=cg2:FilterSelect(tp,c13254114.cfilter3,1,1,nil,e,tp,ft)
		if sg:GetFirst():IsAttribute(ATTRIBUTE_WIND) then ft=ft-1 end
		cg:Merge(sg)
		cg2:Sub(sg)
		i=i+1
	end
	Duel.ConfirmCards(1-tp,cg)
	Duel.ShuffleHand(tp)
	cg:KeepAlive()
	e:SetLabelObject(cg)
	local sc=cg:GetFirst()
	i=0
	while i<2 do
		sc:RegisterFlagEffect(13254114,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
		sc=cg:GetNext()
		i=i+1
	end
	sg=cg:Filter(Card.IsAttribute,nil,ATTRIBUTE_WIND)
	sg:AddCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c13254114.thfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,sg:GetCount(),0,0)
end
function c13254114.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13254114.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local cg=e:GetLabelObject()
	local cc=cg:GetCount()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local sc=cg:GetFirst()
		local i=0
		while i<cc do
			if sc:GetFlagEffect(13254114)==0 then cg:RemoveCard(sc) end
			i=i+1
		end
		local sg=cg:Filter(c13254114.spfilter,nil,e,tp)
		if c:IsRelateToEffect(e) then cg:AddCard(c) end
		if c:IsCanBeSpecialSummoned(e,0,tp,false,false) then sg:AddCard(c) end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>=sg:GetCount() then
			Duel.BreakEffect()
			cg:Sub(sg)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
		if cg:GetCount()>0 then
			Duel.SendtoGrave(cg,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c13254114.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_HAND
end
function c13254114.tgfilter(c)
	return c:IsCode(13254031) and c:IsAbleToHand()
end
function c13254114.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c13254114.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_MZONE)
end
function c13254114.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c13254114.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
