--超维母体
function c10113076.initial_effect(c)

	--Synchro or Xyz
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10113076,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,10113076)
	e1:SetTarget(c10113076.sxtg)
	e1:SetOperation(c10113076.sxop)
	c:RegisterEffect(e1) 
	--to extra
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10113176)
	e2:SetCost(c10113076.tdcost)
	e2:SetTarget(c10113076.tdtg)
	e2:SetOperation(c10113076.tdop)
	c:RegisterEffect(e2)	 
end
function c10113076.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c10113076.tdfilter(c)
	return c:IsType(TYPE_SYNCHRO+TYPE_XYZ) and c:IsAbleToExtra()
end
function c10113076.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c10113076.tdfilter(chkc) end
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingTarget(c10113076.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c10113076.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c10113076.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_EXTRA) and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c10113076.sxfilter(c,tp,mc,ct)
	return c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c10113076.sxfilter2,tp,LOCATION_EXTRA,0,1,nil,Group.FromCards(c,mc),ct)
end
function c10113076.sxfilter2(c,mg,ct)
	return (c:IsXyzSummonable(mg,2,2) and ct~=2) or (c:IsSynchroSummonable(nil,mg) and ct~=3)
end
function c10113076.sxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c10113076.sxfilter,tp,LOCATION_HAND,0,1,c,tp,c,1) end
end
function c10113076.sxop(e,tp,eg,ep,ev,re,r,rp)
	local c,op,mc,sxg=e:GetHandler(),0
	if not c:IsRelateToEffect(e) then return end
	local mg1=Duel.GetMatchingGroup(c10113076.sxfilter,tp,LOCATION_HAND,0,c,tp,c,2)
	local mg2=Duel.GetMatchingGroup(c10113076.sxfilter,tp,LOCATION_HAND,0,c,tp,c,3)
	if mg1:GetCount()>0 and mg2:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		  op=Duel.SelectOption(tp,aux.Stringid(10113076,1),aux.Stringid(10113076,2))
	elseif mg1:GetCount()>0 then
		  op=Duel.SelectOption(tp,aux.Stringid(10113076,1))
	elseif mg2:GetCount()>0 then
		  op=Duel.SelectOption(tp,aux.Stringid(10113076,2))
		  op=1
	else return 
	end
	if op==0 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	   mc=mg1:Select(tp,1,1,nil):GetFirst()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   sxg=Duel.SelectMatchingCard(tp,c10113076.sxfilter2,tp,LOCATION_EXTRA,0,1,1,nil,Group.FromCards(c,mc),2)
	   Duel.SynchroSummon(tp,sxg:GetFirst(),nil,Group.FromCards(c,mc))
	else
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	   mc=mg2:Select(tp,1,1,nil):GetFirst()
	   sxg=Duel.SelectMatchingCard(tp,c10113076.sxfilter2,tp,LOCATION_EXTRA,0,1,1,nil,Group.FromCards(c,mc),3)
	   Duel.XyzSummon(tp,sxg:GetFirst(),Group.FromCards(c,mc),2,2)
	end
	Duel.ShuffleHand(tp)
end
