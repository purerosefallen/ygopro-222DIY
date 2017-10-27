--百慕 恋之王牌·丘莉姆
local m=37564453
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
cm.Senya_name_with_prism=true
function cm.initial_effect(c)
	Senya.PrismCommonEffect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(Senya.PrismSpsummonCheck)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
	return Senya.CheckPrism(c) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and e:GetHandler():IsRelateToEffect(e) then
			Duel.ShuffleDeck(tp)
			Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
		end
	end
end
function cm.bm_check_operation(e,tp,eg,ep,ev,re,r,rp,val)
	val[1]=val[1]+1500
end