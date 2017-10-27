--红魔馆的恶魔·蕾米莉亚
function c1151009.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1151009)
	e1:SetTarget(c1151009.tg1)
	e1:SetOperation(c1151009.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,1151010)
	e2:SetCondition(c1151009.con2)
	e2:SetTarget(c1151009.tg2)
	e2:SetOperation(c1151009.op2)
	c:RegisterEffect(e2) 
--
	Duel.AddCustomActivityCounter(1151009,ACTIVITY_SPSUMMON,c1151009.counterfilter) 
end
--
c1151009.named_with_Leimi=1
function c1151009.IsLeimi(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Leimi
end
function c1151009.IsLeisp(c)
	local m=_G["c"..c:GetCode()]
	return c.named_with_Leisp
end
--
function c1151009.counterfilter(c)
	return c:IsRace(RACE_FIEND)
end
--
function c1151009.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(1151009,tp,ACTIVITY_SPSUMMON)==0 end
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTargetRange(1,0)
	e1_1:SetTarget(c1151009.limit1_1)
	Duel.RegisterEffect(e1_1,tp)
end
function c1151009.limit1_1(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsRace(RACE_FIEND)
end
--
function c1151009.tfilter1(c)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_MONSTER)
end
function c1151009.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMatchingGroupCount(c1151009.tfilter1,tp,LOCATION_ONFIELD,0,nil)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_REMOVED)
end
--
function c1151009.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==1 then
				Duel.SortDecktop(tp,tp,1)
			else
				Duel.SortDecktop(tp,tp,2)
			end
		end
	end
end
--
function c1151009.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK 
end
--
function c1151009.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
--
function c1151009.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1151005,0))
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	if tc then
		local t=0
		local opt=Duel.SelectOption(tp,70,71,72)
		if opt==0 then 
			t=TYPE_MONSTER 
		else 
			if opt==1 then 
				t=TYPE_SPELL 
			else t=TYPE_TRAP 
			end
		end
		Duel.ConfirmDecktop(tp,1)
		if tc:IsType(t) then
			if tc:IsAbleToHand() and not (e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) then
				local sel=Duel.SelectOption(tp,aux.Stringid(1151009,1)) 
				if sel==0 then   
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				end
			else 
				if tc:IsAbleToHand() and (e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) then
					local sel=Duel.SelectOption(tp,aux.Stringid(1151009,1),aux.Stringid(1151009,2))
					if sel==0 then
						Duel.SendtoHand(tc,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,tc)
					end
					if sel==1 then
						Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
						Duel.ShuffleDeck(tp)
					end
				else
					if not tc:IsAbleToHand() and (e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)) then
						local sel=Duel.SelectOption(tp,aux.Stringid(1151009,2))
						if sel==0 then
							Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
							Duel.ShuffleDeck(tp)
						end
					end
				end
			end
		else
			Duel.ShuffleDeck(tp)
		end
	end
end


