--utakat sp
local m=37564305
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(Senya.DescriptionInNanahira(0))
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_TO_GRAVE)
	e9:SetCondition(Senya.MokouRebornCondition(false,cm.rcon))
	e9:SetCountLimit(1,m-4000)
	e9:SetTarget(cm.target)
	e9:SetOperation(cm.activate)
	c:RegisterEffect(e9)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(Senya.DescriptionInNanahira(0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetRange(LOCATION_HAND)   
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.dfilter(c,ft)
	if ft<=0 and c:GetSequence()>4 then return false end
	return c:IsRace(RACE_ZOMBIE) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsDestructable() and c:IsFaceup()
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetMZoneCount(tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.dfilter(chkc,ft) end
	if chk==0 then return Duel.IsExistingTarget(cm.dfilter,tp,LOCATION_MZONE,0,1,nil,ft) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.dfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
		local c=e:GetHandler()
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function cm.rcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.filter(c,e,tp)
	return c:IsCode(37564201,37564303,37564906) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Senya.CheckSummonLocation(c,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

