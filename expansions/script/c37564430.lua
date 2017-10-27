--绝对要看的大团圆·终场普莉希拉
local m=37564430
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismXyzProcedure(c,2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(37564765,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_AVAILABLE_BD)
	e1:SetCost(Senya.RemoveOverlayCost(1))
	e1:SetCondition(cm.rmcon)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)	
end
function cm.cfilter(c)
	return Senya.check_set_prism(c) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	return g:GetCount()>6 and g:IsExists(Card.IsType,3,nil,TYPE_XYZ)
end
function cm.rfilter(c,e)
	if e and c:IsImmuneToEffect(e) then return false end
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToDeck()
end
function cm.sfilter(c,e,tp,g)
	return Senya.check_set_prism(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not g or cm.scheck(g,c,tp))
end
function cm.scheck(g,c,tp)
	if c:IsLocation(LOCATION_EXTRA) then return Duel.GetLocationCountFromEx(tp,tp,g,c)>0 end
	return Duel.GetMZoneCount(tp,g,tp)>0
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if chk==0 then return g:GetCount()>0 and Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function cm.gcheck(g,mft,eft)
	local ect=g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
	return ect<=eft and g:GetCount()-ect<=mft
end
function cm.RegisterBuff(c,ec)
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(ec)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	local e2=Effect.CreateEffect(ec)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(c:GetBaseAttack()*2)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	local e2=Effect.CreateEffect(ec)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(function(e,te)
		return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
	end)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2,true)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rfilter,tp,LOCATION_MZONE,0,e:GetHandler(),e)
	if g:GetCount()==0 or not Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,g) then return end
	local ct=Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local sg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	local ft=math.min(Duel.GetUsableMZoneCount(tp),ct)
	local mft=Duel.GetMZoneCount(tp)
	local eft=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and math.min(c29724053[tp],Duel.GetLocationCountFromEx(tp)) or Duel.GetLocationCountFromEx(tp)
	local tg=Senya.SelectGroup(tp,HINTMSG_SPSUMMON,sg,cm.gcheck,nil,1,ft,mft,eft)
	local etg=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
	tg:Sub(etg)
	for tc in aux.Next(etg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		cm.RegisterBuff(tc,e:GetHandler())
	end
	for tc in aux.Next(tg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		cm.RegisterBuff(tc,e:GetHandler())
	end
	Duel.SpecialSummonComplete()
end