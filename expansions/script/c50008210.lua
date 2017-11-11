--请问您今天要来听音乐吗
local m=50008210
local cm=_G["c"..m]
local mil=require("expansions/script/Millux")
cm.is_series_with_rabbit=true
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,function(c)
		return mil.is_series(c,'rabbit')
	end,2,2)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(function(e) return e:GetHandler():IsLinkState() end)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local zone=e:GetHandler():GetLinkedZone()
		if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>1
			and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,zone) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		e:SetLabel(Duel.SelectOption(tp,70,71,72))
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end)
	e4:SetOperation(
	function(e,tp,eg,ep,ev,re,r,rp)
			if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=1 then return end
			local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
			Duel.ConfirmCards(tp,g)
			local sgnum=0
			local opt=e:GetLabel()
			if opt==0 then
				sgnum=g:Filter(Card.IsType,nil,TYPE_MONSTER):GetCount()
			elseif opt==1 then
				sgnum=g:Filter(Card.IsType,nil,TYPE_SPELL):GetCount()
			elseif opt==2 then 
				sgnum=g:Filter(Card.IsType,nil,TYPE_TRAP):GetCount()
			end
			if sgnum>1 then
				local zone=e:GetHandler():GetLinkedZone()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
				local sc=sg:GetFirst()
				local effectnum=0
				if sc then
					if zone~=0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
						and (not sc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
						effectnum=Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP,zone)
					else
						effectnum=Duel.SendtoHand(sc,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,sc)
					end
					local rthg=Duel.GetMatchingGroup(cm.rthfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
					if effectnum~=0 and rthg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
						Duel.BreakEffect()
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
						local rthgs=rthg:Select(tp,1,1,nil)
						Duel.SendtoHand(rthgs,nil,REASON_EFFECT)
					end
				end
			end
		end)
	c:RegisterEffect(e4)
end
function cm.spfilter(c,e,tp,zone)
	return mil.is_series(c,'rabbit') and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (zone~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)))
end
function cm.rthfilter(c)
	return c:IsFaceup() and mil.is_series(c,'rabbit')
end