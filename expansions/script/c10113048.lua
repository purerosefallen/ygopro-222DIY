--狂暴雷克斯
function c10113048.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113048,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,10113048)
	e1:SetTarget(c10113048.sptg)
	e1:SetOperation(c10113048.spop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10113048,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10113148)
	e2:SetCondition(c10113048.setcon)
	e2:SetTarget(c10113048.settg)
	e2:SetOperation(c10113048.setop)
	c:RegisterEffect(e2)
end
function c10113048.setcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	if e:GetHandler():IsReason(REASON_DESTROY) then
	   e:SetLabel(100)
	end
	return true
end
function c10113048.tffilter(c)
	return c:IsRace(RACE_DINOSAUR) and not c:IsForbidden()
end
function c10113048.setfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsAbleToGrave() and c:GetLevel()==8
end
function c10113048.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10113048.tffilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c10113048.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10113048.tffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
	local g=Duel.GetMatchingGroup(c10113048.setfilter,tp,LOCATION_DECK,0,nil)
	if e:GetLabel()==100 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10113048,2)) then
	   Duel.BreakEffect()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	   local tg=g:Select(tp,1,1,nil)
	   Duel.SendtoGrave(tg,REASON_EFFECT)
	end
end
function c10113048.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local loc=LOCATION_ONFIELD 
	if ft<0 then loc=LOCATION_MZONE end
	local g=Duel.GetMatchingGroup(Card.IsCanBeEffectTarget,tp,loc,0,c,e)
	if chkc then return false end
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:GetCount()>=2 and (ft>0 or g:IsExists(Card.IsLocation,-ft+1,nil,LOCATION_MZONE)) 
	end
		local g1,g2=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		if ft<1 then
		   g1=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
		else
		   g1=g:Select(tp,1,1,nil)
		end
		g:RemoveCard(g1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		g2=g:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SetTargetCard(g1)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,tp,loc)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c10113048.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
			Duel.SendtoGrave(c,REASON_RULE)
			return
		end
	end
end